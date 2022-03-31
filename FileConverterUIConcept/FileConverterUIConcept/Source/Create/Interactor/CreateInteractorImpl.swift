//
//  CreateInteractorImpl.swift
//

import UIKit
import Combine
import MVVMiOS
import DataAccess

class CreateInteractorImpl: BaseInteractor, CreateInteractor {

    private var dataFetcherRepository: DataFetcherRepository
    private var orderRepository: OrderRepository

    init(dataFetcherRepository: DataFetcherRepository,
         orderRepository: OrderRepository) {

        self.dataFetcherRepository = dataFetcherRepository
        self.orderRepository = orderRepository
    }

    func saveOrder() { orderRepository.saveOrder() }

    func loadIngredients() -> AnyPublisher<Result<[IngredientDTO], Errors>, Never> { dataFetcherRepository.getIngredients() }

    func addOrder(pizza: PizzaDataModel) { orderRepository.addOrder(pizza: pizza) }
}
