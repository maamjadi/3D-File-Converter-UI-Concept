//
//  BaseSceneDelegate.swift
//  
//
//  Created by Amjadi on 2022. 01. 07..
//

import UIKit
import Swinject

open class BaseSceneDelegate: UIResponder, UIWindowSceneDelegate {

    open var window: UIWindow?

    public var screenProvider: ScreenProvider?
    public var rootNavigationController: TransitionedNavigationController?
    public let containerManager = ContainerManager(container: Container())

    open func initialScreen() -> ScreenViewController? { nil }

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        setupScene()

        let window = UIWindow(windowScene: windowScene)

        guard let initialScreen = initialScreen() else {
            fatalError("The initial screen is nil. Have you overriden the initialViewController function?")
        }

        rootNavigationController = TransitionedNavigationController(rootViewController: initialScreen)

        window.rootViewController = rootNavigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    open func registerDIContainerModules() {
        // register
    }

    private func setupScene() {
        registerDIContainerModules()

        initLogger()
        initScreenProvider()
    }

    private func initScreenProvider() {
        screenProvider = containerManager.instance(type: ScreenProvider.self)
        screenProvider?.containerManager = containerManager
    }

    private func initLogger() {
        var logger = containerManager.instance(type: Logger.self)
        logger?.isEnabled = true
        logger?.logLevel = LogSeverity.debug
    }
}
