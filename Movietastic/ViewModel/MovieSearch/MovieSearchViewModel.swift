//
//  MovieSearchViewModel.swift
//  Movietastic
//
//  Created by Macbook Pro on 04/10/2020.
//

import Foundation

protocol MovieSearchViewModelDelegate {
    func searchReturned(with movies: [MovieModel])
}

class MovieSearchViewModel: NSObject {
    var delegate: MovieSearchViewModelDelegate?
    var isPaginating    = false
    var pageNo          = 1
}

extension MovieSearchViewModel {
    func searchMovies(with name: String, andStartPage startPage: Bool = false) {
        if startPage {
            pageNo = 1
        }
        
        if !isPaginating {
            isPaginating = true
            
            MovieService.sharedInstance.searchMovieFromServer(with: name, andPage: pageNo) { (movies, error) in
                self.isPaginating = false
                self.delegate?.searchReturned(with: movies)
            }
            pageNo += 1
        }
        
    }
}
