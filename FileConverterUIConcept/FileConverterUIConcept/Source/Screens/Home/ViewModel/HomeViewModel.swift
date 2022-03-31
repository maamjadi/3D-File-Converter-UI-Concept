//
//  HomeViewModel.swift
//

import UIKit
import Combine
import DataAccess
import MVVMiOS

class HomeViewModel: BaseViewModel<HomeRouter, HomeInteractor, HomeAnalyticsController> {

    let showAlertDialog = PassthroughSubject<Void, Never>()

    @Published var data = [HomeDelegateImpl.DataType]()

    var updatedDataIndex: Int?
    var deleteDocument: ((Int, Int) -> Void)?
    var addOrUpdateDocument: ((DocumentMetadataModel) -> Void)?

    func set(with dataSet: [DocumentMetadataModel]) {
        updatedDataIndex = nil
        data = dataSet.compactMap({ (false, $0) })
    }

    func delete(_ identifier: (Int)) {

        for (index, cellData) in data.enumerated() where cellData.metadataModel?.uniqueIdentifier == identifier {
            self.data.remove(at: index)
            updatedDataIndex = index
        }

        deleteDocument?(identifier, updatedDataIndex ?? 0)
    }

    func insert(_ data: HomeDelegateImpl.DataType) {
        let delegateData = delegate?.data
        updatedDataIndex = (delegateData != nil) ? (delegateData!.isEmpty ? 0 : delegateData!.count - 1) : nil
        data.append(data)
    }

    func updateData(with data: HomeDelegateImpl.DataType, at index: Int) {
        updatedDataIndex = index

        if let metadataModel = data.metadataModel {
            addOrUpdateDocument?(metadataModel)
        }
        self.data[index] = data
    }
}
