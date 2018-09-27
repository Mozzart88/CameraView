//
//  ViewController.swift
//  CameraView
//
//  Created by Ivan Timokhov on 27/09/2018.
//  Copyright © 2018 Ivan Timokhov. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var previewView: PreviewView!
    var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCaptureSession()
                }
            }
        default:
            return
        }
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        self.previewView.videoPreviewLayer.session = self.captureSession
        
        self.captureSession.commitConfiguration()
        self.captureSession.startRunning()
        
    }
    
    override func viewDidAppear() {
        view.window?.level = .floating
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setupCaptureSession() {
        self.captureSession = AVCaptureSession()
    }


}

