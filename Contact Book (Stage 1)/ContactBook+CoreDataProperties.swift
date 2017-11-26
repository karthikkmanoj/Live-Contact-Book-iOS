//
//  ContactBook+CoreDataProperties.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 25/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import Foundation
import CoreData


extension ContactBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactBook> {
        return NSFetchRequest<ContactBook>(entityName: "ContactBook")
    }

    @NSManaged public var birthday: NSDate?
    @NSManaged public var currentLocation: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String?
    @NSManaged public var mobileNumber: Int64
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var photo: NSObject?

}
