//
//  MovieService.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import Foundation
import CoreData

class MovieService {
    
    // MARK: Variables
    
    static let sharedInstance   = MovieService()
    var managedContext          = AppDelegate.sharedInstance.persistentContainer.viewContext
    let decoder                 = JSONDecoder()
    let encoder                 = JSONEncoder()
    
    let randomMovieNames        = ["inception", "matrix", "fast", "hulk", "train", "gone"]
    let baseURL                 = "www.omdbapi.com"
    let apiKey                  = "e3ff1211"
    
    
    // MARK: Service Calls
    
    func syncMoviesWithServer(completion: @escaping ([MovieModel]) -> Void ) {
        
        var movies      = [MovieModel]()
        var apiCount    = 0
        
        for randName in self.randomMovieNames {
            apiCount += 1
            var components = URLComponents()
            components.scheme = "https"
            components.host = self.baseURL
            components.path = ""
            components.queryItems = [
                URLQueryItem(name: "apikey", value: self.apiKey),
                URLQueryItem(name: "s", value: randName),
                URLQueryItem(name: "page", value: "1")
            ]
            
            NetworkingClient.sharedInstance.execute(with: components.url!, andRequestMethod: .get) { (jsonResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion([])
                }
                else {
                    do {
                        if let jsonResponseObj = jsonResponse?[0] {
                            let jsonResDict = jsonResponseObj as NSDictionary
                            if let movieObj = jsonResDict.object(forKey: "Search") as? NSObject {
                                let jsonData    = try JSONSerialization.data(withJSONObject: movieObj, options: .prettyPrinted)
                                let jsonString  = String(data: jsonData, encoding: .utf8)!
//                                print(jsonString)
                                let moviesLocal = try self.decoder.decode([MovieModel].self, from: jsonString.data(using: .utf8)!)
                                for movieObj in moviesLocal {
                                    movies.append(movieObj)
                                }
                                
                                if apiCount == self.randomMovieNames.count {
                                    self.saveMoviesToDB(withMovies: movies) { (done) in
                                        completion(movies)
                                    }
                                }
                            }
                        }
                    }
                    catch {
                        completion([])
                    }
                }
            }
        }
    }
    
    func searchMovie(with str: String, completion: @escaping ([MovieModel]) -> Void) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", str)
        request.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        do {
            let result = try managedContext.fetch(request)
            if result.count == 0 {
                searchMovieFromServer(with: str) { (movies, error)  in
                    completion(movies)
                }
            }
            else {
                var movies: [MovieModel] = []
                for movieLocal in result {
                    movies.append(MovieModel(withEntiy: movieLocal))
                }
                
                completion(movies)
            }
        }
        catch {
            print("Error while fetching Request")
        }
    }
    
    func searchMovieFromServer(with str: String, andPage pageNo: Int = 1, completion: @escaping ([MovieModel], Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.baseURL
        components.path = ""
        components.queryItems = [
            URLQueryItem(name: "apikey", value: self.apiKey),
            URLQueryItem(name: "s", value: str),
            URLQueryItem(name: "page", value: String(pageNo))
        ]
        
        NetworkingClient.sharedInstance.execute(with: components.url!, andRequestMethod: .get) { (jsonResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([], nil)
            }
            else {
                do {
                    if let jsonResponseObj = jsonResponse?[0] {
                        let jsonResDict = jsonResponseObj as NSDictionary
                        if jsonResDict.object(forKey: "Error") != nil {
                            completion([], UrlErrors.detailsNotFound)
                        }
                        else {
                            if let movieObj = jsonResDict.object(forKey: "Search") as? NSObject {
                                let jsonData    = try JSONSerialization.data(withJSONObject: movieObj, options: .prettyPrinted)
                                let jsonString  = String(data: jsonData, encoding: .utf8)!
//                                print(jsonString)
                                let movies = try self.decoder.decode([MovieModel].self, from: jsonString.data(using: .utf8)!)
                                
                                self.saveMoviesToDB(withMovies: movies) { (done) in
                                    completion(movies, nil)
                                }
                            }
                        }
                    }
                }
                catch {
                    completion([], nil)
                }
            }
        }
    }
    
    func getMovieDetails(for movie: MovieModel, completion: @escaping (MovieModel, Error?) -> Void) {
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@ && actors != ''", movie.imdbID)
        
        do {
            let result = try managedContext.fetch(request)
            if result.count > 0 {
                let movie = MovieModel(withEntiy: result[0])
                completion(movie, nil)
            }
            else {
                var components = URLComponents()
                components.scheme = "https"
                components.host = self.baseURL
                components.path = ""
                components.queryItems = [
                    URLQueryItem(name: "apikey", value: self.apiKey),
                    URLQueryItem(name: "i", value: movie.imdbID)
                ]
                
                
                NetworkingClient.sharedInstance.execute(with: components.url!) { (jsonResponse, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(MovieModel(), error)
                    }
                    else {
                        do {
                            if let jsonResponseObj = jsonResponse?[0] {
                                let jsonResDict = jsonResponseObj as NSDictionary
                                
                                if jsonResDict.object(forKey: "Error") != nil {
                                    completion(MovieModel(), UrlErrors.detailsNotFound)
                                }
                                else {
                                    let jsonData    = try JSONSerialization.data(withJSONObject: jsonResDict, options: .prettyPrinted)
                                    let jsonString  = String(data: jsonData, encoding: .utf8)!
//                                    print(jsonString)
                                    let movie = try self.decoder.decode(MovieModel.self, from: jsonString.data(using: .utf8)!)
                                    
                                    self.saveMoviesToDB(withMovies: [movie]) { (done) in
                                        completion(movie, nil)
                                    }
                                }
                            }
                        }
                        catch {
                            completion(movie, nil)
                        }
                    }
                }
            }
        }
        catch {
            print("Error while fetching Request")
        }
    }
    
    
    // MARK: Core Data Crud
    
    func getMoviesFromDB(withPage page: Int = 1, completion: @escaping ([MovieModel]) -> Void) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = 10 * (page - 1)
        
        print(page)
        
        do {
            let result = try managedContext.fetch(request)
            var movies: [MovieModel] = []
            for movieLocal in result {
                movies.append(MovieModel(withEntiy: movieLocal))
            }
            
            completion(movies)
        }
        catch {
            completion([])
            print("Error while fetching Request")
        }
    }
    
    func searchFromDB(withImdbID imdbID: String, completion: @escaping (Bool) -> Void) {
        
        
    }
    
    func deleteAllFromDB(completion: @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSManagedObject.AppManagedObjects.Movie)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
        saveContext()
        completion(true)
    }
    
    func saveMoviesToDB(withMovies movies: [MovieModel], completion: (Bool) -> Void) {
        for movieLocal in movies {
            var movie       = Movie()
            var rating      = Rating()
            var movieFound  = false
            
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            request.predicate = NSPredicate(format: "imdbID == %@", movieLocal.imdbID)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do {
                let result = try managedContext.fetch(request)
                
                if result.count > 0 {
                    movie       = result[0]
                    rating      = result[0].rating ?? NSEntityDescription.insertNewObject(forEntityName: NSManagedObject.AppManagedObjects.Rating, into: managedContext) as! Rating
                    movieFound  = true
                }
                
            }
            catch {
                print("Error while fetching Request")
            }
            
            if !movieFound {
                movie = NSEntityDescription.insertNewObject(forEntityName: NSManagedObject.AppManagedObjects.Movie, into: managedContext) as! Movie
                rating = NSEntityDescription.insertNewObject(forEntityName: NSManagedObject.AppManagedObjects.Rating, into: managedContext) as! Rating
                
                movie.title           = movieLocal.Title
                movie.year            = movieLocal.Year
                movie.rated           = movieLocal.Rated
                movie.released        = movieLocal.Released
                movie.runtime         = movieLocal.Runtime
                movie.genre           = movieLocal.Genre
                movie.director        = movieLocal.Director
                movie.writer          = movieLocal.Writer
                movie.actors          = movieLocal.Actors
                movie.plot            = movieLocal.Plot
                movie.language        = movieLocal.Language
                movie.country         = movieLocal.Country
                movie.awards          = movieLocal.Awards
                movie.poster          = movieLocal.Poster
                movie.metaScore       = movieLocal.Metascore
                movie.imdbRating      = movieLocal.imdbRating
                movie.imdbVotes       = movieLocal.imdbVotes
                movie.imdbID          = movieLocal.imdbID
                movie.movieType       = movieLocal.MovieType
                movie.dvd             = movieLocal.DVD
                movie.boxOffice       = movieLocal.BoxOffice
                movie.production      = movieLocal.Production
                movie.website         = movieLocal.Website
                movie.response        = movieLocal.Response
                rating.source         = movieLocal.Rating.source
                rating.value          = movieLocal.Rating.value
                movie.rating          = rating
            }
            else {
                movie.setValue(movie.title, forKey: "title")
                movie.setValue(movie.year, forKey: "year")
                movie.setValue(movie.rated, forKey: "rated")
                movie.setValue(movie.released, forKey: "released")
                movie.setValue(movie.runtime, forKey: "runtime")
                movie.setValue(movie.genre, forKey: "genre")
                movie.setValue(movie.director, forKey: "director")
                movie.setValue(movie.writer, forKey: "writer")
                movie.setValue(movie.actors, forKey: "actors")
                movie.setValue(movie.plot, forKey: "plot")
                movie.setValue(movie.language, forKey: "language")
                movie.setValue(movie.country, forKey: "country")
                movie.setValue(movie.awards, forKey: "awards")
                movie.setValue(movie.poster, forKey: "poster")
                movie.setValue(movie.metaScore, forKey: "metaScore")
                movie.setValue(movie.imdbRating, forKey: "imdbRating")
                movie.setValue(movie.imdbVotes, forKey: "imdbVotes")
                movie.setValue(movie.imdbID, forKey: "imdbID")
                movie.setValue(movie.movieType, forKey: "movieType")
                movie.setValue(movie.dvd, forKey: "dvd")
                movie.setValue(movie.boxOffice, forKey: "boxOffice")
                movie.setValue(movie.production, forKey: "production")
                movie.setValue(movie.website, forKey: "website")
            }
        }
        saveContext()
        completion(true)
    }
    
    func createNewMovie() {
        
    }
    
    func saveContext() {
        do {
            try managedContext.save()
        }
        catch {
            print("Couldnt Save due to Error: \(error)")
        }
    }
}
