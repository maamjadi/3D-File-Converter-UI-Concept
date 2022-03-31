//
//  HomeViewModel.swift
//

import UIKit
import Combine
import DataAccess
import MVVMiOS

class HomeViewModel: BaseViewModel<HomeRouter, HomeInteractor, HomeAnalyticsController> {

    let showAlertDialog = PassthroughSubject<Void, Never>()

    @Published var data = [PizzaDataModel]()

    override func viewModelDidLoad() {
        super.viewModelDidLoad()

        interactor.loadPizzaList()
            .sink { [weak self] result in
                switch result {
                case .success(let pizzaList):
                    self?.data = pizzaList
                case .failure(let error):
                    self?.logger.e(title: "HomeViewModel.loadPizzaList", message: error.localizedDescription)
                }
            }
            .store(in: &subscribers)
    }

    @objc
    func navigateCheckoutScreen() { router.navigateCheckoutScreen() }

    @objc
    func createPizzaNavigation() {
        let pizzaDTO = PizzaDTO(name: Constants.customPizzaName, ingredients: [], imageUrl: nil)
        let customPizza = PizzaDataModel(pizzaDTO: pizzaDTO, ingredientsDTO: [], basePrice: interactor.basePrice)

        navigateCreatePizza(with: customPizza)
    }

    func navigateCreatePizza(with pizzaData: PizzaDataModel) {
        interactor.initializeOrder()
        router.navigateCreateScreen(with: pizzaData)
    }
}

extension HomeViewModel: PizzaCellDelegate {

    func addOrder(with pizzaData: PizzaDataModel) {
        interactor.addOrder(pizza: pizzaData)
        showAlertDialog.send(())
    }
}

fileprivate enum Constants {
    static let customPizzaName = "Custom Pizza"
}
