//
//  InjectorModule.swift
//  
//
//  Created by Amjadi on 2022. 01. 04..
//

import Foundation
import Swinject

open class InjectorModule {

    public let container: Container

    public required init(container: Container) {

        self.container = container
    }

    open func register() {
        // override
    }
}
