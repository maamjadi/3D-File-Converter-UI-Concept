//
//  DocumentBrowserViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import DataAccess
import os.log

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    var receiverViewController: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        allowsDocumentCreation = true
        allowsPickingMultipleItems = false

        browserUserInterfaceStyle = .light
        view.tintColor = UIColor(named: "AccentColor") ?? .blue
    }

    // MARK: UIDocumentBrowserViewControllerDelegate

    //swiftlint:disable line_length
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping (URL?,
                                                                                         UIDocumentBrowserViewController.ImportMode) -> Void) {

        let newDocumentURL: URL? = Bundle.main.url(forResource: "speaker", withExtension: "shapr")

        if newDocumentURL != nil {
            importHandler(newDocumentURL, .copy)
        } else {
            importHandler(nil, .none)
        }
    }
    //swiftlint:enable line_length

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }

        presentDocument(at: sourceURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL,
                         toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         failedToImportDocumentAt documentURL: URL,
                         error: Error?) {
        showAlert("failed import appropriately with error: \(String(describing: error))")
    }

    // MARK: Document Presentation

    var transitionController: UIDocumentBrowserTransitionController?

    func presentDocument(at documentURL: URL) {
        receiverViewController?.setDocument(Document(fileURL: documentURL)) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
