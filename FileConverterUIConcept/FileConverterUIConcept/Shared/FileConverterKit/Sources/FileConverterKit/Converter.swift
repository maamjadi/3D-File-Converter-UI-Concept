//
//  Converter.swift
//  Copyright © 2020 Amin Amjadi. All rights reserved.
//

import Foundation

public final class Converter {

    //TODO: The real conversion logic should be implemented here
    //This function is intended to replicate a process heavy task
    public static func convert(_ importFile: Data? = nil, to exportFormate: String? = nil) -> Data {
        sleep(20)
        return importFile ?? Data()
    }
}
