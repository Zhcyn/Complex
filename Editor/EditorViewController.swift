//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
protocol EditorViewControllerDelegate: class {
    func controllerDidSelectShowLibrary(_ controller: EditorViewController)
}
class EditorViewController: UIViewController {
    weak var delegate: EditorViewControllerDelegate?
    var dataSource: EditorDataSource? {
        didSet { configureDataSource() }
    }
    @IBOutlet var editor: EditorTextView?
    @IBOutlet private var toolbar: UIToolbar?
    private lazy var toolbarWrapper = self.toolbar.flatMap(SafeAreaInputAccessoryViewWrapperView.init)
    override var canBecomeFirstResponder: Bool {
        presentedViewController == nil
    }
    override var inputAccessoryView: UIView? {
        toolbarWrapper
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        editor?.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource?.save()
    }
    @IBAction private func showLibrary() {
        delegate?.controllerDidSelectShowLibrary(self)
    }
    @IBAction private func shareNote() {
        let text = editor?.text ?? ""
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(controller, animated: true)
    }
    @IBAction private func deleteNote() {
        dataSource?.deleteNote()
        editor?.startEditing(animated: true)
    }
    @IBAction func createNewNote() {
        createNewNote(with: nil)
    }
    func createNewNote(with text: String?) {
        if let text = text?.trimmedOrNil {
            dataSource?.createNewNote(with: text)
        } else {
            dataSource?.archiveNote()
        }
        editor?.startEditing(animated: true)
    }
    private func showNote() {
        guard editor?.text != dataSource?.note?.text else { return }
        editor?.text = dataSource?.note?.text
    }
    private func updateNote(with text: String?) {
        if dataSource?.note == nil, text != nil, text != "" {
            dataSource?.createNewNote(with: text)
        } else {
            dataSource?.note?.text = text
            dataSource?.note?.dateModified = Date()
        }
    }
    private func configureDataSource() {
        dataSource?.noteDidUpdate = { [weak self] in
            self?.showNote()
        }
        showNote()
        editor?.startEditing(animated: true)
    }
}
extension EditorViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != dataSource?.note?.text {
            updateNote(with: textView.text)
        }
        dataSource?.save()
    }
    func textViewDidChange(_ textView: UITextView) {
        updateNote(with: textView.text)
    }
}
extension EditorViewController: SlideTransitionable {
    func presentationTransitionWillBegin() {
        resignFirstResponder()
    }
    func presentationTransitionDidEnd(completed: Bool) {
        DispatchQueue.main.async {
            self.becomeFirstResponder(!completed)
        }
    }
    func dismissalTransitionDidEnd(completed: Bool) {
        DispatchQueue.main.async {
            let editorEditing = self.editor?.isFirstResponder ?? false
            self.becomeFirstResponder(completed && !editorEditing)
        }
    }
}
