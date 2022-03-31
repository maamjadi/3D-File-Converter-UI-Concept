//
//  DataAccessModule.swift
//  DataAccess
//
//  Created by Amjadi on 2022. 01. 06..
//

import UIKit
import MVVMiOS
import Swinject

open class DataAccessModule: InjectorModule {

    open override func register() {

        self.container.register(StorageDataRepository.self) { _ in
            StorageDataRepositoryImpl()
        }
        .inObjectScope(.container)
    }
}
