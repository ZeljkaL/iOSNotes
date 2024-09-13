import CoreData
import UIKit

class NoteDetailVC: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    
    var selectedNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
