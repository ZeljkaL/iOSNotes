import UIKit
import CoreData

class NoteTableView: UITableViewController {
    
    enum Constants {
        static let editNoteSegue = "editNote"
    }
    
    var notes: [Note] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
    }
    
    private func fetchNotes() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Failed to fetch local notes.")
        }
   }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCellID", 
                                                     for: indexPath) as! NoteCell
        
        let currentNote = notes[indexPath.row]
        noteCell.titleLabel.text = currentNote.title
        noteCell.descLabel.text = currentNote.desc

        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.editNoteSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editNoteSegue {
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteDetailVC
            
            let selectedNote = notes[indexPath.row]
            noteDetail?.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

