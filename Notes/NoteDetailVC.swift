import CoreData
import UIKit

class NoteDetailVC: UIViewController, UIImagePickerControllerDelegate,              UINavigationControllerDelegate  {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    
    var selectedNote: Note?
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let note = selectedNote {
            titleTF.text = note.title
            descTV.text = note.desc
        }
    }

    @IBAction func onSave(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let note = selectedNote {
            note.title = titleTF.text
            note.desc = descTV.text
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to save modified note: \(error)")
            }
        } else {
            addNewNote(context: context)
        }
    }
    
    private func addNewNote(context: NSManagedObjectContext) {
        let newNote = Note(context: context)
        newNote.title = titleTF.text
        newNote.desc = descTV.text
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save note: \(error)")
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let note = selectedNote {
            context.delete(note)
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to delete note: \(error)")
            }
        }
    }
    
    // Method to open gallery on tapping photo button
    @IBAction func onPhotoTap(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method to handle image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                // Call OCR processor to recognize text in the selected image
                self.performOCR(on: selectedImage)
            }
        }
    }

    // OCR processing method
    func performOCR(on image: UIImage) {
        let ocrProcessor = OCRProcessor()
        ocrProcessor.recognizeTextInImage(image) { [weak self] recognizedText in
            DispatchQueue.main.async {
                if let recognizedText = recognizedText {
                    // Append recognized text to the description text view
                    self?.descTV.text += "\n\(recognizedText)"
                } else {
                    print("No text recognized or OCR failed.")
                }
            }
        }
    }
}
