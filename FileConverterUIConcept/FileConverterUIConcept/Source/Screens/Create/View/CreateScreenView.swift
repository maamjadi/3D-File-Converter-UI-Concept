//
//  CreateScreenView.swift
//

import UIKit
import Combine
import MVVMiOS
import Kingfisher
import DataAccess

class CreateScreenView: BaseScreenView<CreateViewModel> {

    @IBOutlet weak var pizzaBoardImageView: UIImageView!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    let selectedTableView = PassthroughSubject<(IngredientDTO, ItemTableViewCell), Never>()


    override func setupUI() {
        super.setupUI()

        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        if let imageUrl = viewModel.pizzaDataModel.imageUrl {
            let url = URL(string: imageUrl)

            pizzaImageView.kf.setImage(with: url,
                                       placeholder: nil,
                                       options: [.transition(.fade(0.5))])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setButtonPrice()

        controller?.navigationItem.title = (viewModel.pizzaDataModel.ingredients.isEmpty ? Constants.defaultTitle : viewModel.pizzaDataModel.name.uppercased())
    }

    func setButtonPrice() {
        addToCartButton.setTitle(String(format: Constants.buttonTitleFormatText, String(viewModel.pizzaDataModel.price)), for: .normal)
    }
}

extension CreateScreenView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.data.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }

        let ingredient = viewModel.data[indexPath.row]
        cell.ingredient = ingredient
        cell.itemImageView.isHidden = !viewModel.pizzaDataModel.ingredients.contains(ingredient)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell,
              let ingredient = cell.ingredient else { return }

        selectedTableView.send((ingredient, cell))

        setButtonPrice()
    }
}

fileprivate enum Constants {
    static let cellNibName = "ItemTableViewCell"
    static let cellIdentifier = "ingredientCell"
    static let buttonTitleFormatText = "ADD TO CART ($%@)"
    static let defaultTitle = "CREATE A PIZZA"
}
