//
//  CreateViewModel.swift
//

import UIKit
import Combine
import DataAccess
import MVVMiOS

class CreateViewModel: BaseViewModel<CreateRouter, CreateInteractor, CreateAnalyticsController> {

    let showAlertDialog = PassthroughSubject<Void, Never>()

    @Published var data = [IngredientDTO]()

    var pizzaDataModel: PizzaDataModel!

    override func viewModelDidLoad() {
        super.viewModelDidLoad()

        loadIngredients()
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()

        saveOrder()
    }

    func loadIngredients() {
        interactor.loadIngredients()
            .sink { [weak self] result in
                switch result {
                case .success(let ingredients):
                    self?.data = ingredients
                case .failure(let error):
                    self?.logger.e(title: "CreateViewModel.loadPizzaList", message: error.localizedDescription)
                }
            }
            .store(in: &subscribers)
    }

    func saveOrder() {
        interactor.saveOrder()
    }

    func addOrder() {
        interactor.addOrder(pizza: pizzaDataModel)
        showAlertDialog.send(())
    }
}
