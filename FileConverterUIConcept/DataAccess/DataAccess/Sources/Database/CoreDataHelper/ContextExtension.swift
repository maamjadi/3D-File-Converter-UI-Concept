//
//  CoreDataHelper.swift
//
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func cd_saveToPersistentStore() {
        performAndWait {
            if hasChanges {
                var saveResult = false
                defer {
                    if saveResult, let parent = self.parent {
                        parent.cd_saveToPersistentStore()
                    }
                }
                do {
                    try self.save()
                    saveResult = true
                } catch {
                    print("NSManagedObjectContext", "\(error.localizedDescription)")
                    if let error = error as NSError? {
                        print("NSManagedObjectContext", "\(error.userInfo)")
                    }
                    saveResult = false
                }
            }
        }
    }
}
