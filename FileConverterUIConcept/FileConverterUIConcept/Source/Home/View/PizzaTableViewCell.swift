//
//  PizzaTableViewCell.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 01. 10..
//

import UIKit
import Kingfisher
import DataAccess
import Combine

protocol PizzaCellDelegate: AnyObject {
    func addOrder(with pizzaData: PizzaDataModel)
}

class PizzaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCardButton: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!

    private weak var pizzaCellDelegate: PizzaCellDelegate?

    private var pizzaDataModel: PizzaDataModel? {
        didSet {
            guard let pizzaDataModel = pizzaDataModel else { return }

            titleLabel.text = pizzaDataModel.name
            titleLabel.sizeToFit()

            var descriptionText = ""
            for (index, ingredient) in pizzaDataModel.ingredients.enumerated() {
                descriptionText =
                    descriptionText
                    + "\(ingredient.name)"
                    + ((index == pizzaDataModel.ingredients.count - 1) ? "." : ", ")
            }
            descriptionLabel.text = descriptionText
            descriptionLabel.sizeToFit()

            if let imageUrl = pizzaDataModel.imageUrl {
                let url = URL(string: imageUrl)

                pizzaImageView.kf.setImage(with: url,
                                           placeholder: nil,
                                           options: [.transition(.fade(0.5))])
            }

            priceLabel.text = "$" + String(Int(pizzaDataModel.price))

            layoutIfNeeded()
        }
    }

    func configure(_ pizzaDataModel: PizzaDataModel, pizzaCellDelegate: PizzaCellDelegate) {
        self.pizzaDataModel = pizzaDataModel
        self.pizzaCellDelegate = pizzaCellDelegate
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addToCardButtonAction))
        addToCardButton.addGestureRecognizer(tapGesture)

        addToCardButton.layer.cornerRadius = 4
    }

    @objc
    private func addToCardButtonAction() {
        guard let pizzaDataModel = pizzaDataModel else { return }

        pizzaCellDelegate?.addOrder(with: pizzaDataModel)
    }
}
