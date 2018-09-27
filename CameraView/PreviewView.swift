//
//  PreviewView.swift
//  CameraView
//
//  Created by Ivan Timokhov on 27/09/2018.
//  Copyright © 2018 Ivan Timokhov. All rights reserved.
//

import Cocoa
import AVFoundation

class PreviewView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        self.layer = AVCaptureVideoPreviewLayer()
    }
//    override var layer: CALayer? = {
//        return AVCaptureVideoPreviewLayer.self
//    }()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        self.layer = AVCaptureVideoPreviewLayer()
        return self.layer as! AVCaptureVideoPreviewLayer
    }
    
}
