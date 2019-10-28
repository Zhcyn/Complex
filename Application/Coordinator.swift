//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class Coordinator {
    let store: CoreDataStore
    let settings: Settings
    let purger: Purger
    let editorViewController: EditorViewController
    lazy var libraryContainer: UINavigationController = {
        let storyboardId = "Library"
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId) as? UINavigationController else { fatalError("Wrong controller id or type.") }
        return controller
    }()
    lazy var libraryViewController: LibraryViewController = {
        guard let controller = libraryContainer.viewControllers.first as? LibraryViewController else { fatalError("Wrong root controller.") }
        controller.delegate = self
        controller.dataSource = LibraryDataSource(store: store, settings: settings)
        return controller
    }()
    lazy var transitionController = TransitionController()
    init(store: CoreDataStore, purger: Purger, settings: Settings, editorViewController: EditorViewController) {
        self.store = store
        self.purger = purger
        self.settings = settings
        self.editorViewController = editorViewController
        self.editorViewController.delegate = self
        self.editorViewController.dataSource = EditorDataSource(store: store, settings: settings)
        configureSlideToLibraryGesture()
    }
}
private extension Coordinator {
    func showLibrary() {
        libraryViewController.selectedNote = editorViewController.dataSource?.note
        editorViewController.view.endEditing(true)
        transitionController.prepareForLibraryTransition(for: libraryContainer)
        editorViewController.present(libraryContainer, animated: true)
    }
    func hideLibrary() {
        editorViewController.dismiss(animated: true)
    }
    func showSettings() {
        guard let settingsContainer = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as? UINavigationController,
            let settingsViewController = settingsContainer.topViewController as? SettingsViewController else { fatalError("Wrong storyboard id or controller type.") }
        settingsViewController.delegate = self
        settingsViewController.settings = settings
        transitionController.prepareForSettingsTransition(for: settingsContainer)
        libraryViewController.present(settingsContainer, animated: true)
    }
    func configureSlideToLibraryGesture() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSlideToLibraryPan(sender:)))
        editorViewController.editor?.panGestureRecognizer.shouldRequireFailure(of: panRecognizer)
        editorViewController.view.addGestureRecognizer(panRecognizer)
    }
    @objc func handleSlideToLibraryPan(sender: UIPanGestureRecognizer) {
        transitionController.libraryInteractionController.handlePan(for: sender, transitionType: .presentation, performTransition: showLibrary)
    }
}
extension Coordinator: EditorViewControllerDelegate {
    func controllerDidSelectShowLibrary(_ controller: EditorViewController) {
        showLibrary()
    }
}
extension Coordinator: LibraryViewControllerDelegate {
    func controllerDidSelectShowSettings(_ controller: LibraryViewController) {
        showSettings()
    }
    func controller(_ controller: LibraryViewController, didSelectNote note: Note) {
        hideLibrary()
        editorViewController.dataSource?.note = note
    }
    func controller(_ controller: LibraryViewController, didSelectCreateNewNoteWithText text: String?) {
        hideLibrary()
        editorViewController.createNewNote(with: text)
    }
}
extension Coordinator: SettingsViewControllerDelegate {
    func controllerDidFinish(_ controller: SettingsViewController) {
        libraryContainer.dismiss(animated: true)
    }
}
