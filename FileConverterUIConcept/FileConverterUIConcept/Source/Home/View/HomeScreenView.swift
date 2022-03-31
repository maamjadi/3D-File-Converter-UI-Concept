//
//  HomeScreenView.swift
//

import UIKit
import Combine
import MVVMiOS
import DataAccess

class HomeScreenView: BaseScreenView<HomeViewModel> {
    
    @IBOutlet weak var tableView: UITableView!

    let selectedTableView = PassthroughSubject<PizzaDataModel, Never>()

    override func setupUI() {
        super.setupUI()

        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        controller?.navigationItem.title = Constants.navItemTitle

        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: Constants.rightBarButtonImageName),
                                             style: .plain,
                                             target: self,
                                             action: #selector(viewModel.navigateCheckoutScreen))
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: Constants.leftBarButtonImageName),
                                            style: .plain,
                                            target: self,
                                            action: #selector(viewModel.createPizzaNavigation))

        controller?.navigationItem.leftBarButtonItems = [leftBarButton]
        controller?.navigationItem.rightBarButtonItems = [rightBarButton]
    }
}

extension HomeScreenView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.data.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                       for: indexPath) as? PizzaTableViewCell else { return UITableViewCell() }

        cell.configure(viewModel.data[indexPath.row], pizzaCellDelegate: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableView.send(viewModel.data[indexPath.row])
    }
}

fileprivate enum Constants {
    static let cellNibName = "PizzaTableViewCell"
    static let cellIdentifier = "homeCell"
    static let navItemTitle = "Nenno's pizza"
    static let rightBarButtonImageName = "plus"
    static let leftBarButtonImageName = "ic_cart_navbar"
}
