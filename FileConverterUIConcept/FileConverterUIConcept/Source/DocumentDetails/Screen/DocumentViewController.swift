//
//  DocumentViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import FileConverterKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var headerContainerView: UIView!

    var documentMetadata: DocumentMetadataModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        documentNameLabel.text = documentMetadata?.localizedName ?? ""
    }

    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true, completion: nil)
    }
}
