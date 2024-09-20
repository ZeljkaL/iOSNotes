//
//  OCRProcessor.swift
//  Notes
//
//  Created by Zeljka Lazarevic on 20. 9. 2024..
//

import Foundation
import UIKit
import Vision

class OCRProcessor {
    
    // Method to recognize text from the image using Vision framework
    func recognizeTextInImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        // Create a text recognition request
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Process the results of the request
            let observations = request.results as? [VNRecognizedTextObservation]
            let recognizedStrings = observations?.compactMap { observation in
                // Get the best candidate
                return observation.topCandidates(1).first?.string
            }
            
            // Join recognized strings into a single output string
            let fullText = recognizedStrings?.joined(separator: "\n")
            completion(fullText)
        }
        
        // Set the recognition level and language (optional)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"] // You can add more languages as needed
        
        // Create an image request handler
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error performing OCR request: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
