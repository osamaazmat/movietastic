//
//  Movie+CoreDataProperties.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var actors: String?
    @NSManaged public var awards: String?
    @NSManaged public var boxOffice: String?
    @NSManaged public var country: String?
    @NSManaged public var director: String?
    @NSManaged public var dvd: String?
    @NSManaged public var genre: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var imdbRating: String?
    @NSManaged public var imdbVotes: String?
    @NSManaged public var language: String?
    @NSManaged public var metaScore: String?
    @NSManaged public var movieType: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var production: String?
    @NSManaged public var rated: String?
    @NSManaged public var released: String?
    @NSManaged public var response: String?
    @NSManaged public var runtime: String?
    @NSManaged public var title: String?
    @NSManaged public var website: String?
    @NSManaged public var writer: String?
    @NSManaged public var year: String?
    @NSManaged public var rating: Rating?

}

extension Movie : Identifiable {

}
