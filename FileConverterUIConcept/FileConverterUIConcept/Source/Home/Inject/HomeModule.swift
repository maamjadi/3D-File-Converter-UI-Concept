//
//  HomeModule.swift
//

import UIKit
import MVVMiOS
import DataAccess

class HomeModule: InjectorModule {

    override func register() {

        self.container.register(HomeScreenView.self) { resolver in

            let viewModel = resolver.resolve(HomeViewModel.self)!
            let view = HomeScreenView(viewModel: viewModel)
            let binder = HomeBinder(viewModel: viewModel, view: view)

            view.setBinder(binder)

            return view
        }

        self.container.register(HomeViewModel.self) { resolver in

            HomeViewModel(router: resolver.resolve(HomeRouter.self)!,
                          interactor: resolver.resolve(HomeInteractor.self)!,
                          logger: resolver.resolve(Logger.self)!,
                          analyticsController: resolver.resolve(HomeAnalyticsController.self)!)

        }

        self.container.register(HomeRouter.self) { resolver in HomeRouterImpl(screenProvider: resolver.resolve(ScreenProvider.self)!) }

        self.container.register(HomeInteractor.self) { resolver in
            HomeInteractorImpl(dataFetcherRepository: resolver.resolve(DataFetcherRepository.self)!,
                                           orderRepository: resolver.resolve(OrderRepository.self)!)
        }

        self.container.register(HomeAnalyticsController.self) { _ in HomeAnalyticsControllerImpl() }
    }
}
