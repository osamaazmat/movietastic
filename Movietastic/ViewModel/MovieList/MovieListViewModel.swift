//
//  MovieListViewModel.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import Foundation

protocol MovieListViewModelDelegate {
    func moviesReturned(withMovies movies: [MovieModel])
}

class MovieListViewModel: NSObject {
    var delegate: MovieListViewModelDelegate?
    var isPaginating    = false
    var pageNo          = 1
}

extension MovieListViewModel {
    
    func getMovies(andStartPage startPage: Bool = false) {
        if startPage {
            pageNo = 1
        }
        
        if !isPaginating {
            isPaginating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                MovieService.sharedInstance.getMoviesFromDB(withPage: self.pageNo) { (movies) in
                    self.isPaginating = false
                    self.delegate?.moviesReturned(withMovies: movies)
                }
            }
            pageNo += 1
        }
    }
    
}
