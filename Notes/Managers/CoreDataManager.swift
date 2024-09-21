import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        
        // Load persistent stores
        container.loadPersistentStores { storeDescription, error in
            // Use guard to handle the error
            guard error == nil else {
                fatalError(">>> [CoreDataManager] Failed to initialize Persistance Container. Error \(error!), \(error!.localizedDescription)")
            }
        }
        
        return container
    }()
    
    private init() {}

    func fetch() -> [Note] {
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        do {
            return try context.fetch(request)
        } catch {
            print(">>> CoreDataManager: Failed to fetch notes: \(error)")
            return []
        }
    }
    
    func save() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError(">>> [CoreDataManager] Failed to save changes. Error \(nserror), \(nserror.userInfo)")
        }
    }

    func delete(note: Note) {
        context.delete(note)
        save()
    }
}
