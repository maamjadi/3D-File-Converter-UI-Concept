//
//  BaseViewModel.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit
import Combine

/// Window Controller base class. Subclass it to provide your Controller with a Window
open class BaseViewModel<R, I, A>: ViewModel {

    public var router: R
    public let interactor: I
    public let logger: Logger
    public let analyticsController: A

    public var subscribers = Set<AnyCancellable>()

    public var isDataLoaded = PassthroughSubject<Bool?, Never>()
    public var isDataLoading = PassthroughSubject<Bool?, Never>()
    public var isDataLoadFailed = PassthroughSubject<Bool?, Never>()

    public required init(router: R, interactor: I, logger: Logger, analyticsController: A) {

        self.interactor = interactor
        self.router = router
        self.logger = logger
        self.analyticsController = analyticsController

        self.initEventHandlers()
    }

    open func setViewController(viewController: BaseViewController) {
        if let router = self.router as? BaseRouter {
            router.viewController = viewController
        }
    }

    /// Called on Screen View's viewDidLoad()
    open func viewModelDidLoad() {
        // override to kick off processes
    }

    open func viewWillAppear() {
        // override to kick off processes
    }

    open func viewDidAppear() {
        // The view calls this method when the view did appear on the screen
    }

    open func viewDidDisappear() {
        // The view calls this method when the view did disappear on the screen
    }

    open func viewWillDisappear() {
        // The view calls this method when the view will disappear on the screen
    }

    open func initEventHandlers() {
        // override to initialise Rx event handlers
    }

    deinit {
        print("view model deinitialised")
    }

    public func dataIsLoaded() {
        isDataLoading.send(false)
        isDataLoaded.send(true)
        isDataLoadFailed.send(false)
    }

    public func dataIsLoading() {
        isDataLoading.send(true)
        isDataLoaded.send(false)
        isDataLoadFailed.send(false)
    }

    public func dataFailedToLoad() {
        isDataLoading.send(false)
        isDataLoaded.send(false)
        isDataLoadFailed.send(true)
    }
}
