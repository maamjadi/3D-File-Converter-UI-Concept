//
//  HomeBinder.swift
//

import UIKit
import MVVMiOS
import Combine

class HomeBinder: BaseBinder<HomeViewModel, HomeScreenView> {

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
            }
            .store(in: &subscribers)

        view.selectedTableView
            .sink { [weak self] pizzaData in
                self?.viewModel.navigateCreatePizza(with: pizzaData)
        }
        .store(in: &subscribers)
    }
}
