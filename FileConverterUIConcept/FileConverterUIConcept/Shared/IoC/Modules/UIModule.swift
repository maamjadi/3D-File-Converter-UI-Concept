//
//  UIModule.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 01. 07..
//

import MVVMiOS

class UIModule: InjectorModule {

    override func register() {
        
        self.container.register(ScreenProvider.self) { _ in
            ScreenProviderImpl()
        }
        .inObjectScope(.container)
    }
}
