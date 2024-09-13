//
//  Note.swift
//  Notes
//
//  Created by Zeljka Lazarevic on 13. 9. 2024..
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
    
    
}
