//
//  MovieDetailViewModel.swift
//  Movietastic
//
//  Created by Macbook Pro on 03/10/2020.
//

import Foundation

protocol MovieDetailViewModelDelegate {
    func detailsReturned(for movie: MovieModel)
    func detailsNotFound(with error: Error)
}

class MovieDetailViewModel: NSObject {
    var delegate: MovieDetailViewModelDelegate?
    var movie   = MovieModel()
}

extension MovieDetailViewModel {
    func getMovieDetails(for movie: MovieModel) {
        MovieService.sharedInstance.getMovieDetails(for: movie) { (movie, error)  in
            if let error = error {
                self.delegate?.detailsNotFound(with: error)
            }
            else {
                self.delegate?.detailsReturned(for: movie)
            }
        }
    }
}
