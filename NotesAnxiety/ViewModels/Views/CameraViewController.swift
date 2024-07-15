//
//  CameraViewController.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 14/07/24.
//

import PhotosUI
import Foundation
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var photo: UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = context.coordinator
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCapturePhotoCaptureDelegate {
        var parent: CameraViewController
        
        var captureSession: AVCaptureSession!
        var capturePhotoOutput: AVCapturePhotoOutput!
        var theCamera: AVCaptureDevice!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        
        let photoQualityPrioritizationMode = AVCapturePhotoOutput.QualityPrioritization.speed
        
        init(_ imagePickerController: CameraViewController) {
            self.parent = imagePickerController
        }
        
        // called when a picture has been taken
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }
            parent.photo = image   // <--- the photo image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
}
