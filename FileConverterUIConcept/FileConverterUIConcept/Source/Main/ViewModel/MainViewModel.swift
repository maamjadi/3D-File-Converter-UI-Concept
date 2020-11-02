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

    func convert(_ document: Document,
                 to exportFormate: String? = nil,
                 at index: Int) {

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let data = FileConverterKit.Converter.convert(document.data, to: exportFormate)

            DispatchQueue.main.async {
                self?.delegate?.data.append((document, data, exportFormate, index))
                document.close(completionHandler: nil)
            }
        }
    }
}
