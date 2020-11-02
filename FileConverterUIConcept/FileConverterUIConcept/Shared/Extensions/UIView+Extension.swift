//
//  UIView+Extension.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit

extension UIView {

    func setRoundCorners(with defaultSize: CGFloat? = nil) {
        let size = defaultSize != nil ? defaultSize! : (max(bounds.width, bounds.height) / 2)
        layer.cornerRadius = size
    }
}
