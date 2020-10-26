//
//  HomeViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import Foundation

class HomeViewModel: BaseViewModel<HomeDelegateImpl> {

    func loadConvertedFiles() {
        delegate?.data = []
    }
}
