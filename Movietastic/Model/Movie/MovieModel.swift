//
//  MovieModel.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import Foundation

class MovieModel: Codable {
    
    var Title: String           = ""
    var Year: String            = ""
    var Rated: String           = ""
    var Released: String        = ""
    var Runtime: String         = ""
    var Genre: String           = ""
    var Director: String        = ""
    var Writer: String          = ""
    var Actors: String          = ""
    var Plot: String            = ""
    var Language: String        = ""
    var Country: String         = ""
    var Awards: String          = ""
    var Poster: String          = ""
    var Metascore: String       = ""
    var imdbRating: String      = ""
    var imdbVotes: String       = ""
    var imdbID: String          = ""
    var MovieType: String       = ""
    var DVD: String             = ""
    var BoxOffice: String       = ""
    var Production: String      = ""
    var Website: String         = ""
    var Response: String        = ""
    var Rating                  = RatingsModel()
    
    enum CodingKeys: String, CodingKey {
        case Title
        case Year
        case Rated
        case Released
        case Runtime
        case Genre
        case Director
        case Writer
        case Actors
        case Plot
        case Language
        case Country
        case Awards
        case Poster
        case Metascore
        case imdbRating
        case imdbVotes
        case imdbID
        case MovieType = "Type"
        case DVD
        case BoxOffice
        case Production
        case Website
        case Response
        case Rating
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        Title       = try container.decodeIfPresent(String.self, forKey: CodingKeys.Title) ?? ""
        Year        = try container.decodeIfPresent(String.self, forKey: CodingKeys.Year) ?? ""
        Rated       = try container.decodeIfPresent(String.self, forKey: CodingKeys.Rated) ?? ""
        Released    = try container.decodeIfPresent(String.self, forKey: CodingKeys.Released) ?? ""
        Runtime     = try container.decodeIfPresent(String.self, forKey: CodingKeys.Runtime) ?? ""
        Genre       = try container.decodeIfPresent(String.self, forKey: CodingKeys.Genre) ?? ""
        Director    = try container.decodeIfPresent(String.self, forKey: CodingKeys.Director) ?? ""
        Writer      = try container.decodeIfPresent(String.self, forKey: CodingKeys.Writer) ?? ""
        Actors      = try container.decodeIfPresent(String.self, forKey: CodingKeys.Actors) ?? ""
        Plot        = try container.decodeIfPresent(String.self, forKey: CodingKeys.Plot) ?? ""
        Language    = try container.decodeIfPresent(String.self, forKey: CodingKeys.Language) ?? ""
        Country     = try container.decodeIfPresent(String.self, forKey: CodingKeys.Country) ?? ""
        Awards      = try container.decodeIfPresent(String.self, forKey: CodingKeys.Awards) ?? ""
        Poster      = try container.decodeIfPresent(String.self, forKey: CodingKeys.Poster) ?? ""
        Metascore   = try container.decodeIfPresent(String.self, forKey: CodingKeys.Metascore) ?? ""
        imdbRating  = try container.decodeIfPresent(String.self, forKey: CodingKeys.imdbRating) ?? ""
        imdbVotes   = try container.decodeIfPresent(String.self, forKey: CodingKeys.imdbVotes) ?? ""
        imdbID      = try container.decodeIfPresent(String.self, forKey: CodingKeys.imdbID) ?? ""
        MovieType   = try container.decodeIfPresent(String.self, forKey: CodingKeys.MovieType) ?? ""
        DVD         = try container.decodeIfPresent(String.self, forKey: CodingKeys.DVD) ?? ""
        BoxOffice   = try container.decodeIfPresent(String.self, forKey: CodingKeys.BoxOffice) ?? ""
        Production  = try container.decodeIfPresent(String.self, forKey: CodingKeys.Production) ?? ""
        Website     = try container.decodeIfPresent(String.self, forKey: CodingKeys.Website) ?? ""
        Response    = try container.decodeIfPresent(String.self, forKey: CodingKeys.Response) ?? ""
        Rating      = try container.decodeIfPresent(RatingsModel.self, forKey: CodingKeys.Rating) ?? RatingsModel()
    }
    
    init() {
        Title           = ""
        Year            = ""
        Rated           = ""
        Released        = ""
        Runtime         = ""
        Genre           = ""
        Director        = ""
        Writer          = ""
        Actors          = ""
        Plot            = ""
        Language        = ""
        Country         = ""
        Awards          = ""
        Poster          = ""
        Metascore       = ""
        imdbRating      = ""
        imdbVotes       = ""
        imdbID          = ""
        MovieType       = ""
        DVD             = ""
        BoxOffice       = ""
        Production      = ""
        Website         = ""
        Response        = ""
        Rating          = RatingsModel()
    }
    
    convenience init(withEntiy entity: Movie?) {
        self.init()
        if let entity = entity {
            Title           = entity.title ?? ""
            Year            = entity.year ?? ""
            Rated           = entity.rated ?? ""
            Released        = entity.released ?? ""
            Runtime         = entity.runtime ?? ""
            Genre           = entity.genre ?? ""
            Director        = entity.director ?? ""
            Writer          = entity.writer ?? ""
            Actors          = entity.actors ?? ""
            Plot            = entity.plot ?? ""
            Language        = entity.language ?? ""
            Country         = entity.country ?? ""
            Awards          = entity.awards ?? ""
            Poster          = entity.poster ?? ""
            Metascore       = entity.metaScore ?? ""
            imdbRating      = entity.imdbRating ?? ""
            imdbVotes       = entity.imdbVotes ?? ""
            imdbID          = entity.imdbID ?? ""
            MovieType       = entity.movieType ?? ""
            DVD             = entity.dvd ?? ""
            BoxOffice       = entity.boxOffice ?? ""
            Production      = entity.production ?? ""
            Website         = entity.website ?? ""
            Response        = entity.response ?? ""
            Rating          = RatingsModel(withEntity: entity.rating)
        }
    }
}

class RatingsModel: Codable {
    
    var source: String  = ""
    var value: String   = ""

    enum CodingKeys: String, CodingKey {
        case source
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        source  = try container.decodeIfPresent(String.self, forKey: CodingKeys.source) ?? ""
        value   = try container.decodeIfPresent(String.self, forKey: CodingKeys.value) ?? ""
    }
    
    init() {
        source  = ""
        value   = ""
    }
    
    convenience init(withEntity entity: Rating?) {
        self.init()
        if let entity = entity {
            source  = entity.source ?? ""
            value   = entity.value ?? ""
        }
    }
    
}
