//
//  MovieDetailViewController.swift
//  Movietastic
//
//  Created by Macbook Pro on 03/10/2020.
//

import UIKit
import SDWebImage

class MovieDetailViewController: BaseViewController {

    
    // MARK: Outlets And Variables
    
    var viewModel: MovieDetailViewModel?
    var movie = MovieModel()
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleView: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var otherDetailLabel: UILabel!
    
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}


// MARK: Private Functions

extension MovieDetailViewController {
    
    private func setupVC() {
        let viewModel               = MovieDetailViewModel()
        self.viewModel              = viewModel
        self.viewModel?.delegate    = self
        
        self.mainScrollView.isHidden = true
        
        self.startLoading()
        self.viewModel?.getMovieDetails(for: self.movie)
    }
    
    private func getStringForOtherDetails(from movie: MovieModel) -> String {
        
        let writerString    = "Writer: \(movie.Writer) \n \n"
        let directorString  = "Director: \(movie.Director) \n \n"
        let actorsString    = "Actors: \(movie.Actors) \n \n"
        let awardsString    = "Awards: \(movie.Awards) \n \n"
        
        
        return writerString + directorString + actorsString + awardsString
    }
}


extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func detailsNotFound(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func detailsReturned(for movie: MovieModel) {
        self.stopLoading()
        
        mainImageView.sd_setImage(with: URL(string: movie.Poster), placeholderImage: UIImage(named: "placeholder.png"))
        mainTitleView.text      = movie.Title
        yearLabel.text          = movie.Year
        ratedLabel.text         = movie.Rated
        releasedLabel.text      = movie.Released
        runTimeLabel.text       = movie.Runtime
        genreLabel.text         = movie.Genre
        plotLabel.text          = movie.Plot
        otherDetailLabel.text   = getStringForOtherDetails(from: movie)
        
        self.mainScrollView.isHidden = false
    }
}
