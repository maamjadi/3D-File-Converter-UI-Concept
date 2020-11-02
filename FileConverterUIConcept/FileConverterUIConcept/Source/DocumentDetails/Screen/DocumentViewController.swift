//
//  DocumentViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import FileConverterKit

// MARK: - UIViewController

class DocumentViewController: BaseViewController<BaseScreenDelegateImpl, DocumentViewModel> {

    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var formateNameLabel: UILabel!
    @IBOutlet weak var fileURLLabel: UILabel!
    @IBOutlet weak var lastModificationLabel: UILabel!

    var documentMetadata: DocumentMetadataModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        documentNameLabel.text = documentMetadata.localizedName
        formateNameLabel.text = documentMetadata.fileType
        fileURLLabel.text = documentMetadata.fileURL?.absoluteString

        if let modificationDate = documentMetadata.fileModificationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            lastModificationLabel.text = dateFormatter.string(from: modificationDate)

        } else { lastModificationLabel.text = nil }
    }

    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteDocument() {
        viewModel.deleteDocument?(documentMetadata.uniqueIdentifier)
        dismissDocumentViewController()
    }
}
