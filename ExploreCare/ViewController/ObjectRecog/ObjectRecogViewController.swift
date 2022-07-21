//
//  ObjectRecogViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 23/06/22.
//

import UIKit
import Vision
import AVFoundation

class ObjectRecogViewController: UIViewController {
    
    @IBOutlet weak var objectTableView: UITableView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var boxesCameraView: DrawingBoundingBoxView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var bgLevelView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    public var mission: Mission?
    private let measure = Measure()
    var player:AVAudioPlayer!
    
    // MARK: - Init Model Core ML
    let objectDectectionModel = YOLOv3Tiny()
    
    // MARK: - Vision Properties
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    var isInferencing = false
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 1)
    var lastExecution = Date()
    
    var timer = Timer()
    var confettiCouter = 60
    var matchIndex = 0
    let confettiView = KConfettiView()
    var indexList: [Int] = []
    
    var viewModel = ObjectRecogViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpModel()
        setUpCamera()
        setupTable()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
        
        //push value to iwatch
        let name = UserDefaults.standard.string(forKey: loginNameDef)
        viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: false)
    }
    
    @IBAction func finishButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        let vc = FinishViewController()
        vc.mission = self.mission
        vc.level = mission?.level ?? 0
        window.rootViewController = vc
        
        //push value to iwatch
        let name = UserDefaults.standard.string(forKey: loginNameDef)
        viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: false)
    }
}

// MARK: - VideoCaptureDelegate
extension ObjectRecogViewController: VideoCaptureDelegate {
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.videoDelegate = self
        videoCapture.fps = 60
        videoCapture.setUp(sessionPreset: .hd4K3840x2160) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    self.cameraView.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            
            // start of measure
            self.measure.start()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
    
    func playSound(soundName: String) {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch let error{
            print(error.localizedDescription)
        }
    }
}

// MARK: - Vision & CoreML
extension ObjectRecogViewController {
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: objectDectectionModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("fail to create vision model")
        }
    }
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.measure.label(with: "endInference")
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            //  print(predictions.first?.labels.first?.identifier ?? "nil")
            // print(predictions.first?.labels.first?.confidence ?? -1)
            
            //matching object\
            let _ = mission?.object.map({ object in
                if object.objectName == predictions.first?.labels.first?.identifier {
                    matchIndex += 1
                    
                    let index = mission?.object.enumerated().filter{$0.element.objectName == object.objectName}.map{$0.offset}
                    if matchIndex == 1 {
                        matchingObject(indexObject: (index?.first)!)
                    }
                }
            })
            
            DispatchQueue.main.async {
                self.boxesCameraView.predictedObjects = predictions
                //                self.labelsTableView.reloadData()
                
                // end of measure
                self.measure.stop()
                
                self.isInferencing = false
            }
        } else {
            // end of measure
            self.measure.stop()
            
            self.isInferencing = false
        }
        self.semaphore.signal()
    }
}

// MARK: - TableViewMission
extension ObjectRecogViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTable() {
        UITableView.appearance().separatorColor = .clear
        
        objectTableView.dataSource = self
        objectTableView.delegate = self
        
        let nib = UINib(nibName: "ObjectTableViewCell", bundle: nil)
        
        objectTableView.register(nib, forCellReuseIdentifier: "ObjectTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        
        cell.selectionStyle = .none
        cell.object = mission?.object
        cell.updateObjectCell(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mission?.object.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = self.objectTableView.cellForRow(at: indexPath)!
        selectedCell.contentView.layer.cornerRadius = 12
        selectedCell.contentView.backgroundColor = .green
        
        playObjectSound(indexObject: indexPath.row)
    }
}

// MARK: - CustomAllert
extension ObjectRecogViewController: CustomAlertDelegate {
    func onNegativeButtonPressed(_ alert: CustomAllertViewController, indexObject: Int) {
        matchIndex = 0
        timer.invalidate()
        stopConfetti()
        
        indexList.append(indexObject)
        if indexList.uniqued().count == 3 {
            finishButton.isHidden = false
        }
        
        //push value to iwatch
        let name = UserDefaults.standard.string(forKey: loginNameDef)
        viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: true)
    }
    
    func onPositiveButttonPressed(_ alert: CustomAllertViewController, indexObject: Int) {
        playObjectSound(indexObject: indexObject)
    }
}

// MARK: - Custom function
extension ObjectRecogViewController {
    
    @objc func updateCounter() {
        if confettiCouter > 0 {
            print("\(confettiCouter) show confetti")
            confettiCouter -= 1
        }else {
            stopConfetti()
        }
    }
    
    func setupView() {
        bgLevelView.layer.cornerRadius = 8
        AppUtility.lockOrientation(.landscapeRight)
        levelLabel.text = "Level \(mission?.level ?? 0)"
        finishButton.isHidden = true
        objectTableView.allowsSelection = false
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = cameraView.bounds
    }
    
    func stopConfetti() {
        confettiView.removeFromSuperview()
    }
    
    func showConfetti() {
        confettiView.frame = view.bounds
        confettiView.setup()
        view.addSubview(confettiView)
    }
    
    func showCustomAllert(indexObject: Int) {
        let customAllert = CustomAllertViewController()
        customAllert.allertTitle = (mission?.object[indexObject].objectName)!
        customAllert.allertNegativeButtonTitle = "Back"
        customAllert.allertPositiveButtonTitle = "Speaker"
        customAllert.indexObject = indexObject
        customAllert.allertImage = mission?.object[indexObject].objectImage
        customAllert.delegate = self
        customAllert.show()
    }
    
    func playObjectSound(indexObject: Int) {
        switch mission?.object[indexObject].objectName {
        case "backpack": playSound(soundName: "backpack.mp3")
        case "tvmonitor": playSound(soundName: "tv.mp3")
        case "clock": playSound(soundName: "clock.mp3")
        case "book": playSound(soundName: "book.mp3")
        case "laptop": playSound(soundName: "laptop.mp3")
        case "cup": playSound(soundName: "cup.mp3")
        default:
            playSound(soundName: "laptop.mp3")
        }
    }
    
    func matchingObject(indexObject: Int) {
        DispatchQueue.main.async { [self] in
            //selected row
            let indexPath = IndexPath(row: indexObject, section: 0)
            objectTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            objectTableView.delegate?.tableView?(objectTableView, didSelectRowAt: indexPath)
            
            showConfetti()
            showCustomAllert(indexObject: indexObject)
            playSound(soundName: "correct.aiff")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            
            //push value to iwatch
            let name = UserDefaults.standard.string(forKey: loginNameDef)
            viewModel.sendMessageToIwatch(name: name, time: 0, startExplore: false)
        }
    }
}
