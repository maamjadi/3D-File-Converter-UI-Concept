//
//  LoggerImpl.swift
//  
//
//  Created by Amjadi on 2021. 03. 31..
//

import Foundation

public class LoggerImpl: Logger {

    public var isEnabled: Bool = true

    public var logLevel: LogSeverity = LogSeverity.debug

    public func d(title: String, message: String) {
        writeLog(title: title, message: message, severity: .debug)
    }

    public func w(title: String, message: String) {
        writeLog(title: title, message: message, severity: .warning)
    }

    public func i(title: String, message: String) {
        writeLog(title: title, message: message, severity: .info)
    }

    public func e(title: String, message: String) {
        writeLog(title: title, message: message, severity: .error)
    }

    private func writeLog(title: String, message: String, severity: LogSeverity) {
        if isEnabled && severity.hashValue >= logLevel.hashValue {

            let date = Date()
            print("\(severity.rawValue) \(date) \(severity.rawValue) [\(title)] \(message)")
        }
    }
}

public enum LogSeverity: String {

    case debug = "📘", info = "📓", warning = "📙", error = "📕"
}
