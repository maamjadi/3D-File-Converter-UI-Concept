//
//  HomeRouterImpl.swift
//

import UIKit
import MVVMiOS
import DataAccess

class HomeRouterImpl: BaseRouter, HomeRouter {

    func navigateCreateScreen(with pizzaData: PizzaDataModel) {
        if let createScreenView = (screenProvider as? IOSScreenProvider)?.provideCreateScreen(pizzaData: pizzaData) {
            viewController?.navigationController?.pushViewController(createScreenView, animated: true)
        }
    }

    func navigateCheckoutScreen() {
        if let checkoutScreenView = (screenProvider as? IOSScreenProvider)?.provideCheckoutScreen() {
            viewController?.navigationController?.pushViewController(checkoutScreenView, animated: true)
        }
    }
}
