//
//  MovieListViewController.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import UIKit
import SDWebImage

class MovieListViewController: BaseViewController {

    
    // MARK: Outlets And Variables
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MovieListViewModel?
    var movies: [MovieModel]    = []
    private let refreshControl  = UIRefreshControl()
    var isFresh: Bool = false
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}


// MARK: Private Functions

extension MovieListViewController {
    
    private func setupVC() {
        collectionView.register(UINib(nibName: MovieListCollectionViewCell.cellNibName, bundle: .main), forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMovieData(_:)), for: .valueChanged)

        
        let viewModel               = MovieListViewModel()
        self.viewModel              = viewModel
        self.viewModel?.delegate    = self
        
        self.startLoading()
        self.viewModel?.getMovies()
    }
}


// MARK: Action Methods

extension MovieListViewController {
    @objc func refreshMovieData(_ sender: Any) {
        self.stopLoading()
        if !(self.viewModel?.isPaginating ?? false) {
            isFresh = true
            self.viewModel?.getMovies(andStartPage: true)
        }
    }
    
    @IBAction func onPressSearch(_ sender: Any) {
        let storyBoard: UIStoryboard    = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC               = storyBoard.instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
        movieDetailVC.delegate          = self
        self.present(movieDetailVC, animated: true, completion: nil)
    }
}

// MARK: Collection View Delegate Data Source

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier, for: indexPath as IndexPath) as! MovieListCollectionViewCell
        
        cell.mainImageView.sd_setImage(with: URL(string: movies[indexPath.item].Poster), placeholderImage: UIImage(named: "placeholder.png"))
        cell.mainTitleLabel.text = movies[indexPath.item].Title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToDetails(with: movies[indexPath.item])
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 2) - 8, height: self.view.frame.height / 5)
    }
}


// MARK: UIScrollView Delegate

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > collectionView.contentSize.height - 100 - scrollView.frame.size.height {
            guard !(self.viewModel?.isPaginating ?? false) else {
                return
            }
            
            self.viewModel?.getMovies()
        }
    }
}


// MARK: MovieSearchViewController Delegate

extension MovieListViewController: MovieSearchViewControllerDelegate {
    func moveToMovieDetails(with movie: MovieModel) {
        self.moveToDetails(with: movie)
    }
}


// MARK: MovieListViewModel Delegate

extension MovieListViewController: MovieListViewModelDelegate {
    func moviesReturned(withMovies movies: [MovieModel]) {
//        print(movies)
        if isFresh {
            isFresh = !isFresh
            self.movies = movies
        }
        else {
            self.movies.append(contentsOf: movies)
        }
        collectionView.reloadData()
        self.stopLoading()
        refreshControl.endRefreshing()
    }
}


// MARK: Navigation Methods

extension MovieListViewController {
    func moveToDetails(with movie: MovieModel) {
        let storyBoard: UIStoryboard    = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC               = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.movie             = movie
        
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
