//
//  ViewController.swift
//  CameraView
//
//  Created by Ivan Timokhov on 27/09/2018.
//  Copyright © 2018 Ivan Timokhov. All rights reserved.
//

import Cocoa
import AVFoundation
import CoreBluetooth

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
        // Set window aspect ratio
        view.window?.aspectRatio = NSSize(width: 16, height: 9)

        view.window?.titleVisibility = .visible
        view.window?.title = "Camera View"
        view.window?.styleMask.insert(.fullSizeContentView)
        
        // Set traking area for window
        let trakingArea = NSTrackingArea(rect: self.view.bounds, options: [.mouseEnteredAndExited,.activeAlways], owner: self, userInfo: nil)
        self.view.addTrackingArea(trakingArea)
    }
    
    //MARK:- Create capture session
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
    override func mouseEntered(with event: NSEvent) {
        if let window = view.window {
            let windowIsActive = NSApplication.shared.keyWindow != nil ? true : false
            if !window.styleMask.contains(.titled) && windowIsActive {
                window.styleMask.insert(.titled)
            }
        }
    }
    override func mouseExited(with event: NSEvent) {
        if let window = view.window {
            if window.styleMask.contains(.titled) {
                window.styleMask.remove(.titled)
            }
        }
    }
    
    //MARK:- Create context menu
    override func rightMouseUp(with event: NSEvent) {
        let menu = NSMenu()
        for item in presetSizesArray {
            let menuItem = NSMenuItem(title: item.title, action: #selector(self.setWindowSize), keyEquivalent: "")
            menu.addItem(menuItem)
        }
        NSMenu.popUpContextMenu(menu, with: event, for: self.previewView)
    }
    
    //Mark:- Preset of window size
    enum presetSizes: String {
        case fullScreen = "Full Screen"
        case halfScreen = "1/2"
        case quoterScreen = "1/4"
        case octalScreen = "1/8"
        case sixteenthScreen = "1/16"
    }
    let presetSizesArray: Array<menuItem> = [
        menuItem(title: "Full Screen", value: presetSizes.fullScreen),
        menuItem(title: "1/2", value: presetSizes.halfScreen),
        menuItem(title: "1/4", value: presetSizes.quoterScreen),
        menuItem(title: "1/8", value: presetSizes.octalScreen),
        menuItem(title: "1/16", value: presetSizes.sixteenthScreen),
    ]
    @objc func setWindowSize(_ menuItem: NSMenuItem) {
        guard let presetSize = presetSizesArray[presetSizesArray.index(where: {$0.title == menuItem.title})!].value as? presetSizes else {
            print("Unsetted value")
            return
        }
        guard let screenHeight = self.view.window?.screen?.frame.height else {
            fatalError("Cant take screen height")
        }
        guard let screenWidth = self.view.window?.screen?.frame.width else {
            fatalError("Cant take screen width")
        }
        guard var windowFrame = view.window?.frame else {
            fatalError("No window frame")
        }
        
        var height: CGFloat
        var width: CGFloat!
        var xPoint: CGFloat!
        var yPoint: CGFloat!
        

        switch presetSize {
        case .fullScreen:
            width = screenWidth
            xPoint = 0.0
            yPoint = 0.0

        case .halfScreen:
            width = screenWidth / 2
            
        case .quoterScreen:
            width = screenWidth / 4
        case .octalScreen:
            width = screenWidth / 8
        case .sixteenthScreen:
            width = screenWidth / 16
        }

        height = width / 16 * 9

        if windowFrame.origin.x + width > screenWidth {
            xPoint = screenWidth - width
        } else {
            xPoint = windowFrame.origin.x
        }
        if windowFrame.origin.y + height > screenHeight {
            yPoint = screenHeight - height
        } else {
            yPoint = windowFrame.origin.y
        }

        windowFrame.size = NSMakeSize(width, height)
        windowFrame.origin = NSMakePoint(xPoint, yPoint)

        self.view.window?.setFrame(windowFrame, display: true)
        self.view.setFrameSize(NSSize(width: width, height: height))
        self.view.setBoundsSize(NSSize(width: width, height: height))
    }

    struct menuItem {
        var title: String
        var value: Any
    }
}

