//
//  Array+Extension.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 11. 02..
//

import Foundation

extension Array where Element == Int {

    func getFirstFreeInt() -> Int? {
        var value = 0

        while value < Int.max {
            if !contains(value) {
                return value
            }
            value += 1
        }
        return nil
    }
}
