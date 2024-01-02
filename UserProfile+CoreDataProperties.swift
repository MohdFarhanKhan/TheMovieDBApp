//
//  UserProfile+CoreDataProperties.swift
//  TheMovieDBApp
//
//  Created by Najran Emarah on 06/05/1445 AH.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var age: Int32
    @NSManaged public var movieGenre: String?
    @NSManaged public var movieName: String?
    @NSManaged public var profileName: String?

}

extension UserProfile : Identifiable {

}
