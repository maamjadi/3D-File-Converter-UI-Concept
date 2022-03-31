//
//  ContainerManager.swift
//  
//
//  Created by Amjadi on 2022. 01. 04..
//

import Swinject

public class ContainerManager {

    private var container = Container()
    private var modules: [InjectorModule.Type] = []

    public init(container: Container) {
        self.container = container
    }

    public func registerModule<T: InjectorModule>(injectorModuleType: T.Type) {
        if !modules.contains(where: { item in injectorModuleType == item }) {
            modules.append(injectorModuleType)

            injectorModuleType.init(container: container).register()
        }
    }

    public func unregisterModule(injectorModuleType: InjectorModule.Type) {
        if let moduleIndex = modules.firstIndex(where: { item in injectorModuleType == item }) {
            modules.remove(at: moduleIndex)
        }
    }

    public func registerAll() {
        for module in modules {
            module.init(container: container).register()
        }
    }

    public func instance<T>(type: T.Type) -> T? {
        return container.resolve(type)
    }
}
