//
//  HomeInteractor.swift
//

import UIKit
import Combine
import DataAccess

protocol HomeInteractor {

    var basePrice: Double { get }
    func initializeOrder()
    func loadPizzaList() -> AnyPublisher<Result<[PizzaDataModel], Errors>, Never>
    func addOrder(pizza: PizzaDataModel)
}
