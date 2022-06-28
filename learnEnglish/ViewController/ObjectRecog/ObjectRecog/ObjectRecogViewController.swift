//
//  ObjectRecogViewController.swift
//  learnEnglish
//
//  Created by Rasyid Ridla on 23/06/22.
//

import UIKit
import Vision

class ObjectRecogViewController: UIViewController {
    
    @IBOutlet weak var objectView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var boxesCameraView: DrawingBoundingBoxView!
    
    var objectTableViewController: ObjectTableViewController!
    
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
    
    // MARK: - TableView Data
    var predictions: [VNRecognizedObjectObservation] = []
    
    // MARK - Performance Measurement Property
    private let 👨‍🔧 = 📏()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
        
        setupTableView()
        
        AppUtility.lockOrientation(.landscapeRight)
    }
    
    //    @IBAction func closeButton(_ sender: Any) {
//        //back to home
//    }
    
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
//        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.rootViewController = TabBarViewController()
    }
    
    private func setupTableView() {
         objectTableViewController = ObjectTableViewController()
        
        addChild(objectTableViewController!)
        objectView.addSubview((objectTableViewController?.view)!)
        objectTableViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            objectTableViewController!.view.leadingAnchor.constraint(equalTo: objectView.leadingAnchor),
            objectTableViewController!.view.trailingAnchor.constraint(equalTo: objectView.trailingAnchor),
            objectTableViewController!.view.topAnchor.constraint(equalTo: objectView.topAnchor),
            objectTableViewController!.view.bottomAnchor.constraint(equalTo: objectView.bottomAnchor)
        ])
        
        objectTableViewController?.didMove(toParent: self)
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: objectDectectionModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError("fail to create vision model")
        }
    }

    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = cameraView.bounds
    }
}

// MARK: - VideoCaptureDelegate
extension ObjectRecogViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

extension ObjectRecogViewController {
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        self.semaphore.wait()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Post-processing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.👨‍🔧.🏷(with: "endInference")
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
//            print(predictions.first?.labels.first?.identifier ?? "nil")
//            print(predictions.first?.labels.first?.confidence ?? -1)
            
            self.predictions = predictions
            DispatchQueue.main.async {
                self.boxesCameraView.predictedObjects = predictions
//                self.labelsTableView.reloadData()

                // end of measure
                self.👨‍🔧.🎬🤚()
                
                self.isInferencing = false
            }
        } else {
            // end of measure
            self.👨‍🔧.🎬🤚()
            
            self.isInferencing = false
        }
        self.semaphore.signal()
    }
}


