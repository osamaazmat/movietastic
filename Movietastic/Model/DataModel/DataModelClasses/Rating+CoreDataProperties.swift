//
//  Rating+CoreDataProperties.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//
//

import Foundation
import CoreData


extension Rating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rating> {
        return NSFetchRequest<Rating>(entityName: "Rating")
    }

    @NSManaged public var source: String?
    @NSManaged public var value: String?
    @NSManaged public var ofMovie: Movie?

}

extension Rating : Identifiable {

}
