//
//  BaseAppDelegate.swift
//  UICShared
//
//  Created by Gabor Kajtar on 11/01/2019.
//  Copyright © 2019 uicentric. All rights reserved.
//

import UIKit
import Swinject

open class BaseAppDelegate: UIResponder, UIApplicationDelegate {

    open var window: UIWindow?
    
    public let containerManager = ContainerManager(container: Container())
    
    public var rootNavigationController: TransitionedNavigationController?
    
    public var screenProvider: ScreenProvider?
    
    open func initialScreen() -> ScreenViewController? {
        
        return nil
    }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerDIContainerModules()
        
        registerStyleSheets()
        
        #if DEBUG
        initLogger()
        #endif
        
        initScreenProvider()
        
        try? initInitialScreen()
        
        return true
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    open func registerDIContainerModules() {
        
        // register
    }
    
    open func registerStyleSheets() {
        
        // register
    }
    
    private func initLogger() {
        
        var logger = containerManager.instance(type: Logger.self)
        logger?.isEnabled = true
        logger?.logLevel = LogSeverity.debug
    }
    
    private func initScreenProvider() {
        
        screenProvider = containerManager.instance(type: ScreenProvider.self)
        screenProvider?.containerManager = containerManager
    }
    
    open func initInitialScreen() throws {
        
        guard let initialScreen = initialScreen() else {
            throw NSError(domain: "The initial screen is nil. Have you overriden the initialViewController function?", code: 101, userInfo: nil)
        }
        
        rootNavigationController = TransitionedNavigationController(rootViewController: initialScreen)
        rootNavigationController?.popTransition = FadePopAnimator()
        rootNavigationController?.pushTransition = FadePushAnimator()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
}
