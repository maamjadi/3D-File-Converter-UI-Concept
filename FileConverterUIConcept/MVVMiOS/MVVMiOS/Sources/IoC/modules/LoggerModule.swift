//
//  LoggerModule.swift
//  
//
//  Created by Amjadi on 2022. 01. 04..
//

import Foundation

public class LoggerModule: InjectorModule {

    public override func register() {
        
        self.container.register(Logger.self) { _ in
            LoggerImpl()
        }
    }
}
