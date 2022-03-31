//
//  EnvironmentConfigManagerImpl.swift
//  DataAccess
//
//  Created by Amjadi on 2022. 01. 17..
//

import Foundation

public class EnvironmentConfigManagerImpl: EnvironmentConfigManager {

    let deviceInfoManager: DeviceInfoManager

    public init(deviceInfoManager: DeviceInfoManager, configFileName: String) {

        self.deviceInfoManager = deviceInfoManager

        /* TODO: assign the future environment config values for different schemas here

         if let path = Bundle.main.path(forResource: configFileName, ofType: "plist"),
         let configDictionary = NSDictionary(contentsOfFile: path),
         let swiftConfigDictionary = configDictionary as? [String: Any] {
         }
         */
    }
}
