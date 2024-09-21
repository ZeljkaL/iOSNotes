import UIKit

class NoteDetailVC: UIViewController, 
                    UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var deleteButton: UIButton!

    public var selectedNote: Note?

    private let imagePicker = UIImagePickerController()
    private let ocrProcessor = OCRProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        deleteButton.isHidden = selectedNote == nil
        
        guard let note = selectedNote else {
            print(">>> [NoteDetailVC] No selected note provided.")
            return
        }
        
        titleTF.text = note.title
        descTV.text = note.desc
    }
    
    @IBAction func onSave(_ sender: Any) {
        let note = selectedNote ?? Note(context: CoreDataManager.shared.context)
        
        note.title = titleTF.text
        note.desc = descTV.text
        CoreDataManager.shared.save()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        guard let note = selectedNote else {
            print(">>> [NoteDetailVC] No note selected for deletion.")
            return
        }
        
        CoreDataManager.shared.delete(note: note)
        navigationController?.popViewController(animated: true)
    }
    
    // Method to open gallery on tapping photo button
    @IBAction func onPhotoTap(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method to handle image selection
    func imagePickerController(_ picker: UIImagePickerController,          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print(">>> [NoteDetailVC] No image selected or image format is invalid.")
                return
            }
            
            // Call OCR processor to recognize text in the selected image
            self.performOCR(on: selectedImage)
        }
    }
    
    private func performOCR(on image: UIImage) {
        ocrProcessor.recognizeTextInImage(image) { [weak self] recognizedText in DispatchQueue.main.async {
                self?.handleRecognizedText(recognizedText)
            }
        }
    }
    
    private func handleRecognizedText(_ recognizedText: String?) {
        guard let recognizedText = recognizedText else {
            print(">>> [NoteDetailVC] No text recognized or OCR failed.")
            return
        }

        // Append recognized text to the description text view
        self.descTV.text += "\(recognizedText)"
    }
}
