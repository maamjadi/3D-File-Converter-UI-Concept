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
    @IBOutlet weak var animationContainerView: AnimationView!
    @IBOutlet weak var renderedImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.setRoundCorners(with: 5)
    }

    var metadataModel: DocumentMetadataModel? {
        didSet {
            if let metadataModel = metadataModel  {
                titleLabel.text = (metadataModel.data != nil ?
                                    metadataModel.localizedName :
                                    ("Converting \(metadataModel.localizedName) to \(String(describing: metadataModel.fileType))..."))
            }
        }
    }

    var isConverting: Bool = true {
        didSet {
            if isConverting {
                animationContainerView.play()
                titleLabel.text = "Converting..."

            } else { animationContainerView.stop() }

            renderedImage.isHidden = isConverting
            titleLabel.font = UIFont(name: (isConverting ? "Avenir-Light" : "Avenir-Black"),
                                     size: 18)
        }
    }

}
