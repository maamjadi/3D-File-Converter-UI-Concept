//
//  IOSScreenProvider.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 01. 07..
//

import UIKit
import MVVMiOS
import DataAccess

protocol IOSScreenProvider: ScreenProvider {
    
    func provideMainScreen() -> ScreenViewController
    func provideHomeScreen() -> ScreenViewController
    func provideCreateScreen() -> ScreenViewController
}
