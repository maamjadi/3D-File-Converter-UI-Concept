//
//  HomeInteractorImpl.swift
//

import UIKit
import Combine
import MVVMiOS
import DataAccess

class HomeInteractorImpl: BaseInteractor, HomeInteractor {

    private var dataFetcherRepository: DataFetcherRepository
    private var orderRepository: OrderRepository

    init(dataFetcherRepository: DataFetcherRepository,
         orderRepository: OrderRepository) {

        self.dataFetcherRepository = dataFetcherRepository
        self.orderRepository = orderRepository
    }

    var basePrice: Double { dataFetcherRepository.basePrice }

    func initializeOrder() { orderRepository.initializeOrder() }

    func loadPizzaList() -> AnyPublisher<Result<[PizzaDataModel], Errors>, Never> { dataFetcherRepository.getPizzaList() }

    func addOrder(pizza: PizzaDataModel) { orderRepository.addOrder(pizza: pizza) }
}
