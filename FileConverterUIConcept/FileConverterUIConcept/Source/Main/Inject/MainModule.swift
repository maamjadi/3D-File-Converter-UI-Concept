//
//  MainModule.swift
//
//  Created by Gabor Kajtar on 09/01/2019.
//  Copyright © 2019 uicentric. All rights reserved.
//

import UIKit
import DataAccess
import Swinject

// swiftlint:disable force_cast
class MainModule: InjectorModule {

    override func register() {

        container.register(MainViewController.self) { resolver in

            MainViewController(nibName: "MainViewController",
                               bundle: Bundle.main,
                               screenProvider: resolver.resolve(ScreenProvider.self)! as! IOSScreenProvider)
        }
    }
}
