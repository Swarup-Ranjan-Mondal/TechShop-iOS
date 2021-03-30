//
//  PhotoPicker.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 21/02/21.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    @Environment(\.presentationMode) private  var presentationMode
    @Binding var imageData: Data?
    let callBack: () -> Void
    
    var configuration = PHPickerConfiguration(
        photoLibrary: PHPhotoLibrary.shared()
    )
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let image = results[0]
            
            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                image.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            let img = object as! UIImage
                            
                            self.parent.imageData = img.jpegData(compressionQuality: 0.50)
                            self.parent.callBack()
                        }
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
