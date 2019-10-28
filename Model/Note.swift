//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import CoreData
@objc(Note)
class Note: NSManagedObject {
    @NSManaged var text: String?
    @NSManaged var dateCreated: Date
    @NSManaged var dateModified: Date
    @NSManaged var isPinned: Bool
    convenience init(in context: NSManagedObjectContext, text: String? = nil, dateCreated: Date = Date(), isPinned: Bool = false) {
        self.init(context: context)
        self.text = text
        self.dateCreated = dateCreated
        self.dateModified = dateCreated
        self.isPinned = isPinned
    }
}
extension Note {
    var title: String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n", maxSplits: 1)
            .first
            .flatMap(String.init)
    }
    var previewText: String? {
        text?.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n+", with: "\n", options: .regularExpression, range: nil)
            .split(separator: "\n", maxSplits: 1)
            .dropFirst()
            .joined(separator: "\n")
    }
}
extension Note {
    static func defaultRequest() -> NSFetchRequest<Note> {
        NSFetchRequest(entityName: String(describing: Note.self))
    }
    static func libraryRequest() -> NSFetchRequest<Note> {
        let request = defaultRequest()
        request.fetchBatchSize = 30
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Note.isPinned), ascending: false),
            NSSortDescriptor(key: #keyPath(Note.dateModified), ascending: false)
        ]
        return request
    }
    static func purgeRequest(before: Date, excludingCurrentNote current: Note?) -> NSFetchRequest<Note> {
        let request = defaultRequest()
        request.includesPropertyValues = false
        if let current = current {
            request.predicate = NSPredicate(format: "(%K = false) AND (%K <= %@) AND (SELF != %@)", #keyPath(Note.isPinned), #keyPath(Note.dateModified), before as NSDate, current)
        } else {
            request.predicate = NSPredicate(format: "(%K = false) AND (%K <= %@)", #keyPath(Note.isPinned), #keyPath(Note.dateModified), before as NSDate)
        }
        return request
    }
}
