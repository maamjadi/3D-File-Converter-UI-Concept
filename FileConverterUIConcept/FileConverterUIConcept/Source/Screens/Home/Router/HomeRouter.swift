//
//  HomeRouter.swift
//

import UIKit
import DataAccess

protocol HomeRouter {

    func navigateCreateScreen(with pizzaData: PizzaDataModel)
    func navigateCheckoutScreen()
}
