////
////  HomeViewModel.swift
////  FileConverterUIConcept
////
////  Created by Amjadi on 2020. 10. 25..
////
//
//import Foundation
//
//class HomeViewModel: BaseViewModel<HomeDelegateImpl> {
//
//    var updatedDataIndex: Int?
//    var deleteDocument: ((Int, Int) -> Void)?
//    var addOrUpdateDocument: ((DocumentMetadataModel) -> Void)?
//
//    func set(with dataSet: [DocumentMetadataModel]) {
//        updatedDataIndex = nil
//        delegate?.data = dataSet.compactMap({ (false, $0) })
//    }
//
//    func delete(_ identifier: (Int)) {
//
//        guard let data = delegate?.data else { return }
//
//        for (index, cellData) in data.enumerated() where cellData.metadataModel?.uniqueIdentifier == identifier {
//            delegate?.data.remove(at: index)
//            updatedDataIndex = index
//        }
//
//        deleteDocument?(identifier, updatedDataIndex ?? 0)
//    }
//
//    func insert(_ data: HomeDelegateImpl.DataType) {
//        let delegateData = delegate?.data
//        updatedDataIndex = (delegateData != nil) ? (delegateData!.isEmpty ? 0 : delegateData!.count - 1) : nil
//        delegate?.data.append(data)
//    }
//
//    func updateData(with data: HomeDelegateImpl.DataType, at index: Int) {
//        updatedDataIndex = index
//
//        if let metadataModel = data.metadataModel {
//            addOrUpdateDocument?(metadataModel)
//        }
//        delegate?.data[index] = data
//    }
//}
