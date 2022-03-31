//
//  CreateInteractor.swift
//

import UIKit
import Combine
import DataAccess

protocol CreateInteractor {

    func saveOrder()
    func loadIngredients() -> AnyPublisher<Result<[IngredientDTO], Errors>, Never>
    func addOrder(pizza: PizzaDataModel)
}
