//
//  User+CoreDataProperties.swift
//  
//
//  Created by pan zhang on 2022/7/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var uid: Int64

}
