//
//  HomeViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import Foundation

class HomeViewModel: BaseViewModel<HomeDelegateImpl> {

    var updatedDataIndex: Int?

    func insert(_ data: HomeDelegateImpl.DataType) {
        let delegateData = delegate?.data
        updatedDataIndex = (delegateData != nil) ? (delegateData!.isEmpty ? 0 : delegateData!.count - 1) : nil
        delegate?.data.append(data)
    }

    func updateData(with data: HomeDelegateImpl.DataType, at index: Int) {
        updatedDataIndex = index
        delegate?.data[index] = data
    }
}
