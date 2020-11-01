//
//  HomeCollectionViewCell.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import Lottie

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var renderedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.setRoundCorners(with: 5)

        animationView.loopMode = .loop

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }

    var metadataModel: DocumentMetadataModel? {
        didSet {
            if let metadataModel = metadataModel,
               let filename = metadataModel.localizedName {

                let fileType = metadataModel.fileType
                let conversionText = "Converting to \(filename)\(fileType ?? "")..."

                titleLabel.text = (metadataModel.data != nil ? filename : conversionText)
            } else {
                titleLabel.text = "Converting..."
            }
        }
    }

    var isConverting: Bool = true {
        didSet {
            if isConverting {
                animationView.play()

            } else { animationView.stop() }

            renderedImage.isHidden = isConverting
            titleLabel.font = UIFont(name: (isConverting ? "Avenir-Light" : "Avenir-Black"),
                                     size: 18)
        }
    }

}
