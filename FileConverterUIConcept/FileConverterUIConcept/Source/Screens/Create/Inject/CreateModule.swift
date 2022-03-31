//
//  CreateModule.swift
//

import UIKit
import MVVMiOS
import DataAccess

class CreateModule: InjectorModule {

    override func register() {

        self.container.register(CreateScreenView.self) { resolver in

            let viewModel = resolver.resolve(CreateViewModel.self)!
            let view = CreateScreenView(viewModel: viewModel)
            let binder = CreateBinder(viewModel: viewModel, view: view)

            view.setBinder(binder)

            return view
        }

        self.container.register(CreateViewModel.self) { resolver in

            CreateViewModel(router: resolver.resolve(CreateRouter.self)!,
                          interactor: resolver.resolve(CreateInteractor.self)!,
                          logger: resolver.resolve(Logger.self)!,
                          analyticsController: resolver.resolve(CreateAnalyticsController.self)!)

        }

        self.container.register(CreateRouter.self) { resolver in CreateRouterImpl(screenProvider: resolver.resolve(ScreenProvider.self)!) }

        self.container.register(CreateInteractor.self) {
            resolver in CreateInteractorImpl(dataFetcherRepository: resolver.resolve(DataFetcherRepository.self)!,
                                           orderRepository: resolver.resolve(OrderRepository.self)!)
        }

        self.container.register(CreateAnalyticsController.self) { _ in CreateAnalyticsControllerImpl() }
    }
}
