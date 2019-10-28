//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import CoreData
class Purger {
    private let context: NSManagedObjectContext
    private let settings: Settings
    private var timer: BackgroundPausingTimer?
    init(context: NSManagedObjectContext, settings: Settings, purgeInterval: TimeInterval = 60, tolerance: TimeInterval = 15) {
        self.context = context
        self.settings = settings
        self.timer = BackgroundPausingTimer(interval: purgeInterval, tolerance: tolerance) { [weak self] in
            self?.purge()
        }
        observeSettings()
        purge()
    }
    @objc private func purge() {
        let deleteAfter = settings.deleteNotesAfter
        guard deleteAfter.isEnabled,
            let deleteBefore = Date().subtracting(deleteAfter.value) else { return }
        let current: Note? = try? settings.lastEditedNoteURI.flatMap(context.fetchObject(withURI:))
        let request = Note.purgeRequest(before: deleteBefore, excludingCurrentNote: current)
        guard let results = try? context.fetch(request),
            !results.isEmpty else { return }
        results.forEach(context.delete)
        try? context.save()
    }
    private func observeSettings() {
        settings.addObserver(self, selector: #selector(purge), name: Settings.Notifications.deleteNotesAfter)
    }
}
