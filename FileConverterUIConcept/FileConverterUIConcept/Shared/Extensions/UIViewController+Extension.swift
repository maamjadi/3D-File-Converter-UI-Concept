//
//  UIViewController+Extension.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 26..
//

import UIKit

extension UIViewController {

    func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default))

        self.present(alertController, animated: true, completion: nil)
    }
}
