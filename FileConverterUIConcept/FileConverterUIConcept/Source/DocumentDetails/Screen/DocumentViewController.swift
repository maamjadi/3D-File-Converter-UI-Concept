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

    var document: UIDocument?

    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
