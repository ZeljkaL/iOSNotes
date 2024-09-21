import UIKit

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
        notes = CoreDataManager.shared.fetch()
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < notes.count else {
            print(">>> [NoteTableView] Index out of bounds: \(indexPath.row) for notes count: \(notes.count)")
            return UITableViewCell() // Return a default cell to avoid crashes
        }
        
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCellID", 
                                                     for: indexPath) as! NoteCell
        let currentNote = notes[indexPath.row]
        noteCell.titleLabel.text = currentNote.title
        noteCell.descLabel.text = currentNote.desc

        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, 
                            numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.editNoteSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.editNoteSegue,
              let indexPath = tableView.indexPathForSelectedRow,
              let noteDetailVC = segue.destination as? NoteDetailVC else {
            print(">>> [NoteTableView] Preparation for segue failed.")
            return
        }
        
        let selectedNote = notes[indexPath.row]
        noteDetailVC.selectedNote = selectedNote
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
