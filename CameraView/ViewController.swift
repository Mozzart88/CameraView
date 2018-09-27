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
        
        // Check authorization status to access the camera
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
        
        // Configure Capture session
        captureSession.beginConfiguration()
        
        // Set video device
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        // Add video device to session
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        // Set the preview window
        self.previewView.videoPreviewLayer.session = self.captureSession
        
        // Commit configuration
        self.captureSession.commitConfiguration()
        
        // Start session
        self.captureSession.startRunning()
        
    }
    
    //MARK:- Set Window properties
    override func viewDidAppear() {
        // Make window allways on top
        view.window?.level = .floating
        // Make window visible on all spaces
        view.window?.collectionBehavior = .canJoinAllSpaces

        view.window?.titleVisibility = .visible
        view.window?.title = "Camera View"
        view.window?.styleMask.insert(.fullSizeContentView)
    }
    
    func setupCaptureSession() {
        self.captureSession = AVCaptureSession()
    }
    
    //MARK:- Make window draggeble
    override func mouseDragged(with event: NSEvent) {
        view.window?.performDrag(with: event)
    }
    
    //MARK:- Set title bar visibility
    override func mouseUp(with event: NSEvent) {
        if let window = view.window {
            if window.styleMask.contains(.titled) {
                window.styleMask.remove(.titled)
            } else {
                window.styleMask.insert(.titled)
            }
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {
        let menu = NSMenu()
        let menuItem480 = NSMenuItem.init(title: "480x270", action: #selector(setWindowSize), keyEquivalent: "")
        menu.addItem(menuItem480)
//        menu.item
        NSMenu.popUpContextMenu(menu, with: event, for: self.previewView)
        
    }
    
    @objc func setWindowSize(_ menuItem: NSMenuItem) {
        
        switch menuItem.title {
        case "480x270":
            var windowFrame = view.window?.frame
            windowFrame?.size = NSMakeSize(420, 220)
            
            self.view.window?.setFrame(windowFrame!, display: true)

        default:
            print("Ooops: \(menuItem.title)")
        }
        
    }
    
    //TODO:- Make preset of window size
    
    //TODO:- Make save window proportions on resize
    
}

