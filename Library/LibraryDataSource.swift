//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import CoreData
enum LibrarySectionType: String {
    case pinned = "1"  
    case unpinned = "0"
}
class LibraryDataSource: NSObject {
    var notesWillChange: ((_ hasIncrementalChanges: Bool) -> ())?
    var sectionDidChange: ((FetchedResultsControllerSectionChange) -> ())?
    var noteDidChange: ((FetchedResultsControllerObjectChange) -> ())?
    var notesDidChange: ((_ hasIncrementalChanges: Bool) -> ())?
    private let store: CoreDataStore
    private let settings: Settings
    private let frc: NSFetchedResultsController<Note>
    private lazy var searcher: FetchedResultsControllerSearcher<Note> = {
        let searcher = FetchedResultsControllerSearcher(frc: frc, searchKeyPath: #keyPath(Note.text), debounceBy: 0.25)
        searcher.resultsDidUpdate = { [weak self] _ in
            self?.notesDidChange?(false)
        }
        return searcher
    }()
    init(store: CoreDataStore, settings: Settings, fetchRequest: NSFetchRequest<Note> = Note.libraryRequest()) {
        self.store = store
        self.settings = settings
        let sectionKey = fetchRequest.sortDescriptors?.first?.key
        assert(sectionKey == #keyPath(Note.isPinned))
        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.viewContext, sectionNameKeyPath: sectionKey, cacheName: nil)
        super.init()
        observeSettings()
        frc.delegate = self
        try? frc.performFetch()
    }
    func search(for term: String?) {
        searcher.search(for: term)
    }
    func expirationDate(for note: Note) -> Date? {
        let deleteAfter = settings.deleteNotesAfter
        guard deleteAfter.isEnabled,
            !note.isPinned else { return nil }
        return note.dateModified.adding(deleteAfter.value)
    }
    var isEmpty: Bool {
        frc.fetchedObjects?.isEmpty ?? true
    }
    var numberOfSections: Int {
        frc.sections?.count ?? 0
    }
    func numberOfNotes(inSection section: Int) -> Int {
        frc.sections?[section].numberOfObjects ?? 0
    }
    func sectionType(for section: Int) -> LibrarySectionType? {
        (frc.sections?[section].name).flatMap(LibrarySectionType.init)
    }
    func note(at indexPath: IndexPath) -> Note {
        frc.object(at: indexPath)
    }
    func indexPath(of note: Note) -> IndexPath? {
        frc.indexPath(forObject: note)
    }
    func deleteNote(at indexPath: IndexPath) {
        let note = frc.object(at: indexPath)
        store.viewContext.delete(note)
        store.save()
    }
    func unpinnedNotes() -> [Note] {
        return frc.fetchedObjects?.filter { !$0.isPinned } ?? []
    }
    func deleteAllUnpinnedNotes() {
        unpinnedNotes().forEach(store.viewContext.delete)
        store.save()
    }
    func save() {
        store.save()
    }
    private func observeSettings() {
         settings.addObserver(self, selector: #selector(deleteNotesAfterSettingDidChange), name: Settings.Notifications.deleteNotesAfter)
    }
    @objc private func deleteNotesAfterSettingDidChange() {
        notesDidChange?(false)
    }
}
extension LibraryDataSource: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesWillChange?(true)
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionDidChange?(.init(type: type, index: sectionIndex))
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange object: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        noteDidChange?(.init(object: object, type: type, indexPath: indexPath, newIndexPath: newIndexPath))
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesDidChange?(true)
    }
}
