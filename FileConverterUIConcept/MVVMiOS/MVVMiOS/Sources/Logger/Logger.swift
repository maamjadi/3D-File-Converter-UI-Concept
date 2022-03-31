//
//  Logger.swift
//  
//
//  Created by Amjadi on 2021. 03. 31..
//

import Foundation

public protocol Logger {

    var isEnabled: Bool { get set }

    var logLevel: LogSeverity { get set }

    func d(title: String, message: String)

    func w(title: String, message: String)

    func i(title: String, message: String)

    func e(title: String, message: String)
}
