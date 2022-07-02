//
//  ObjectRecogViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 23/06/22.
//

import UIKit
import Vision

class ObjectRecogViewController: UIViewController {
    
    @IBOutlet weak var objectTableView: UITableView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var boxesCameraView: DrawingBoundingBoxView!
    @IBOutlet weak var levelLabel: UILabel!
    
    public var mission: Mission?
    private let measure = Measure()
    
    // MARK: - Init Model Core ML
    let objectDectectionModel = YOLOv3Tiny()
    var predictions: [VNRecognizedObjectObservation] = []
    
    // MARK: - Vision Properties
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    var isInferencing = false
    
    // MARK: - AV Property
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 1)
    var lastExecution = Date()
    
    
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
    
    func setupView() {
        AppUtility.lockOrientation(.landscapeRight)
        levelLabel.text = "Level \(mission?.level ?? 0)"
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = cameraView.bounds
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
    }
}

// MARK: - VideoCaptureDelegate
extension ObjectRecogViewController: VideoCaptureDelegate {
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.videoDelegate = self
        videoCapture.fps = 60
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
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
            //            print(predictions.first?.labels.first?.identifier ?? "nil")
            //            print(predictions.first?.labels.first?.confidence ?? -1)
            
            self.predictions = predictions
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
        let objectListData = mission?.object[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        
        cell.selectionStyle = .none
        cell.object = objectListData!
        cell.updateObjectCell(itemIsMatch: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mission?.object.count)!
    }
}
