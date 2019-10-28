//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
import MessageUI
import SafariServices
class AboutViewController: UITableViewController {
    let bundle: Bundle = .main
    let storeURL: URL? = nil  
    let sourceCodeURL = URL(string: "https://github.com/Zhcyn/Complex")
    let privacyPolicyURL = URL(string: "https://github.com/Zhcyn/Complex/blob/master/Privacy")
    let contactAddress = "oolcYoung@web.de"
    let contactSubject = NSLocalizedString("Complex: Feedback", comment: "Feedback email subject")
    lazy var contactMessage: String = "\n\n" + UIDevice.current.formattedDiagnostics(forBundle: .main)
    @IBOutlet private var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = bundle.formattedVersion
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0): contact()
        case (0, 1): rate()
        case (1, 0): showPrivacyPolicy()
        case (1, 1): showSourceCode()
        default: break
        }
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        indexPath.section < 2
    }
}
extension AboutViewController {
    func rate() {
        let app = UIApplication.shared
        guard let url = storeURL,
            app.canOpenURL(url) else { return }
        app.open(url)
    }
    func contact() {
        guard MFMailComposeViewController.canSendMail() else {
            presentAlert(.mailNotAvailable(contactAddress: contactAddress), animated: true)
            return
        }
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setToRecipients([contactAddress])
        mailController.setSubject(contactSubject)
        mailController.setMessageBody(contactMessage, isHTML: false)
        present(mailController, animated: true)
    }
    func showSourceCode() {
        guard let url = sourceCodeURL else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    func showPrivacyPolicy() {
        guard let url = privacyPolicyURL else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
}
extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}
