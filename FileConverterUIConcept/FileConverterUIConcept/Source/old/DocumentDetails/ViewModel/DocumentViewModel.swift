//
//  DocumentViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 11. 02..
//

import Foundation

class DocumentViewModel: BaseViewModel<BaseScreenDelegateImpl> {

    var deleteDocument: ((Int) -> Void)?
}
