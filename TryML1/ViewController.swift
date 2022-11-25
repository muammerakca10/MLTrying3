//
//  ViewController.swift
//  TryML1
//
//  Created by MUAMMER AKCA on 25.11.2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        
        present(imagePicker, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {return}
            
            
            detectImage(image: ciimage)
        }
        imagePicker.dismiss(animated: true)
        
    }
    
    func detectImage(image: CIImage){
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: DogCatRabbitMLTry_1.init(configuration: config).model) else {return}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                    return
                
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
}

