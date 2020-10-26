//
//  MainViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import Foundation
import FileConverterKit
import Magnetic

class MainViewModel: BaseViewModel<MainDelegateImpl> {

    func convert(_ importFile: Data? = nil, to exportFormate: String? = nil) -> Data {

        return FileConverterKit.Converter.convert(importFile, to: exportFormate)
    }
}
