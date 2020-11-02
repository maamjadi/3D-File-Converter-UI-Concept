//
//  DocumentEntity+CoreDataProperties.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 11. 02..
//
//

import Foundation
import CoreData

extension DocumentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentEntity> {
        return NSFetchRequest<DocumentEntity>(entityName: "DocumentEntity")
    }

    @NSManaged public var fileData: Data?
    @NSManaged public var fileType: String?
    @NSManaged public var fileURL: URL?
    @NSManaged public var identifier: Int64
    @NSManaged public var modificationDate: Date?
    @NSManaged public var name: String?

}

extension DocumentEntity: Identifiable {

}
