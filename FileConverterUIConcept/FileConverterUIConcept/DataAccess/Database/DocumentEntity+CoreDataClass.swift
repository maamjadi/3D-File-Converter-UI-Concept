//
//  DocumentEntity+CoreDataClass.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 11. 02..
//
//

import Foundation
import CoreData

@objc(DocumentEntity)
public class DocumentEntity: NSManagedObject {

    class func getItem(with identifier: Int, context: NSManagedObjectContext) -> DocumentEntity? {
        return DocumentEntity.cd_findAll(inContext: context,
                                         predicate: NSPredicate(format: "identifier == \(identifier)"))?.first
    }

    class func getItems(in context: NSManagedObjectContext) -> [DocumentEntity]? {
        return DocumentEntity.cd_findAll(inContext: context)
    }

    class func deleteItem(with identifier: Int, context: NSManagedObjectContext) {
        DocumentEntity.cd_delete(inContext: context,
                                 predicate: NSPredicate(format: "identifier == \(identifier)"))
    }

    @discardableResult
    class func addOrUpdateDocument(from content: DocumentMetadataModel,
                                   context: NSManagedObjectContext) -> DocumentEntity? {

        let documentEntity = (DocumentEntity.getItem(with: content.uniqueIdentifier, context: context) ??
                                DocumentEntity.cd_new(inContext: context))

        documentEntity?.identifier = Int64(content.uniqueIdentifier)
        documentEntity?.name = content.localizedName
        documentEntity?.modificationDate = content.fileModificationDate
        documentEntity?.fileURL = content.fileURL
        documentEntity?.fileType = content.fileType
        documentEntity?.fileData = content.data

        return documentEntity
    }
}
