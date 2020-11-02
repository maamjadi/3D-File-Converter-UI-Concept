//
//  UIViewController+Extension.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 26..
//

import UIKit

extension UIViewController {

    func showAlert(_ message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default))

        self.present(alertController, animated: true, completion: nil)
    }
}
