//
//  ScreenProviderImpl.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 01. 07..
//

import UIKit
import MVVMiOS
import DataAccess

class ScreenProviderImpl: IOSScreenProvider {

    var containerManager: ContainerManager?

    func provideMainScreen() -> ScreenViewController {
        ScreenViewController(screenView: containerManager!.instance(type: MainViewController.self)!)
    }

    func provideHomeScreen() -> ScreenViewController {
        ScreenViewController(screenView: containerManager!.instance(type: HomeScreenView.self)!)
    }

    func provideCreateScreen() -> ScreenViewController {
        ScreenViewController(screenView: containerManager!.instance(type: CreateScreenView.self)!)
    }
}
