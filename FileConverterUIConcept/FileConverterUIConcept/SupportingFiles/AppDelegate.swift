//
//  AppDelegate.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import MVVMiOS
import DataAccess

@main
class AppDelegate: BaseAppDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func initialScreen() -> ScreenViewController? {
        (self.screenProvider as? IOSScreenProvider)?.provideMainScreen()
    }

    func application(_ app: UIApplication,
                     open inputURL: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else { return false }

        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController
        else { return false }

        documentBrowserViewController.revealDocument(at: inputURL,
                                                     importIfNeeded: true) { (revealedDocumentURL, error) in
            if let error = error {
                // Handle the error appropriately
                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
                return
            }

            // Present the Document View Controller for the revealed URL
            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
        }

        return true
    }

    override func registerDIContainerModules() {
        self.containerManager.registerModule(injectorModuleType: LoggerModule.self)
        self.containerManager.registerModule(injectorModuleType: UIModule.self)
        self.containerManager.registerModule(injectorModuleType: DataAccessModule.self)

        self.containerManager.registerModule(injectorModuleType: MainModule.self)
        self.containerManager.registerModule(injectorModuleType: HomeModule.self)
        self.containerManager.registerModule(injectorModuleType: CreateModule.self)
    }

    // MARK: State Preservation and Restoration

    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
