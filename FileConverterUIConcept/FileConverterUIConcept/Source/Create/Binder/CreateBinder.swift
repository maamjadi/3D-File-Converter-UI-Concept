//
//  CreateBinder.swift
//

import UIKit
import MVVMiOS

class CreateBinder: BaseBinder<CreateViewModel, CreateScreenView> {

    override func bind() {
        
        viewModel.$data
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.view.tableView.reloadData()
            }
            .store(in: &subscribers)

        viewModel.showAlertDialog
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.view.controller?.showAlertDialog()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.view.controller?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &subscribers)

        view.addToCartButton.publisher(for: .primaryActionTriggered)
            .sink { [weak self] _ in
                self?.viewModel.addOrder()
            }
            .store(in: &subscribers)

        view.selectedTableView
            .receive(on: RunLoop.main)
            .sink { [weak self] ingredient, cell in

                guard let self = self else { return }


                let ingredientExist = self.viewModel.pizzaDataModel.ingredients.contains(ingredient)

                cell.itemImageView.isHidden = ingredientExist

                if ingredientExist {
                    self.viewModel.pizzaDataModel.ingredients.removeAll(where: { $0.identifier == ingredient.identifier })
                } else {
                    self.viewModel.pizzaDataModel.ingredients.append(ingredient)
                }

                self.view.setButtonPrice()
            }
            .store(in: &subscribers)
    }
}
