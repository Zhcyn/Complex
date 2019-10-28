//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import CoreData
import UIKit
class EditorDataSource {
    var note: Note? {
        didSet {
            guard note != oldValue else { return }
            saveLastEditedNote()
            configureObserver()
            noteDidUpdate?()
        }
    }
    var noteDidUpdate: (() -> ())?
    private let store: CoreDataStore
    private let settings: Settings
    private let center: NotificationCenter
    private var observer: ManagedObjectObserver<Note>?
    init(store: CoreDataStore, settings: Settings, center: NotificationCenter = .default) {
        self.store = store
        self.settings = settings
        self.center = center
        self.note = fetchLastEditedNote()
        archiveNoteIfNecessary()
        configureObserver()
        subscribeToNotifications()
    }
    func createNewNote(with text: String? = nil) {
        let note = Note(in: store.viewContext, text: text)
        save()
        self.note = note
    }
    func archiveNote() {
        note = nil
    }
    func deleteNote() {
        guard let note = note else { return }
        store.viewContext.delete(note)
        save()
    }
    func save() {
        store.save()
    }
    private func configureObserver() {
        guard let note = note else {
            observer = nil
            return
        }
        observer = ManagedObjectObserver(object: note, context: store.viewContext) { [weak self] note, changeType in
            if case .delete = changeType {
                self?.note = nil
            } else {
                self?.noteDidUpdate?()
            }
        }
    }
    private func saveLastEditedNote() {
        assert(!(note?.objectID.isTemporaryID ?? false))
        settings.lastEditedNoteURI = note?.objectID.uriRepresentation()
    }
    private func fetchLastEditedNote() -> Note? {
        guard let uri = settings.lastEditedNoteURI else { return nil }
        return try? store.viewContext.fetchObject(withURI: uri)
    }
    @objc private func archiveNoteIfNecessary() {
        if settings.createNoteAfter.isEnabled,
            let date = settings.createNoteOn,
            date <= Date() {
            archiveNote()
        }
        settings.createNoteOn = nil
    }
    @objc private func didEnterBackground() {
        let createAfter = settings.createNoteAfter
        if createAfter.isEnabled {
            settings.createNoteOn = Date().adding(createAfter.value)
        } else {
            settings.createNoteOn = nil
        }
    }
    @objc private func willEnterForeground() {
        archiveNoteIfNecessary()
    }
    private func subscribeToNotifications() {
        center.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
