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
        
        let request = createTextRecognitionRequest(completion: completion)
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        performOCRRequest(requestHandler: requestHandler, request: request, 
                          completion: completion)
    }

    // Create the text recognition request
    private func createTextRecognitionRequest(completion: @escaping (String?) -> Void) -> VNRecognizeTextRequest {
        return VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(self.processRecognitionResults(request))
        }
    }
    
    // Process the results of the text recognition request
    private func processRecognitionResults(_ request: VNRequest) -> String? {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return nil }
        
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        return recognizedStrings.joined(separator: "\n")
    }
    
    // Perform the OCR request
    private func performOCRRequest(requestHandler: VNImageRequestHandler, request: VNRecognizeTextRequest, completion: @escaping (String?) -> Void) {
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
