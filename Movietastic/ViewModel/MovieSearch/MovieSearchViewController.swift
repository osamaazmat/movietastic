//
//  MovieSearchViewController.swift
//  Movietastic
//
//  Created by Macbook Pro on 04/10/2020.
//

import UIKit
import SDWebImage

protocol MovieSearchViewControllerDelegate {
    func moveToMovieDetails(with movie: MovieModel)
}

class MovieSearchViewController: BaseViewController {

    
    // MARK: Outlets And Variables
    
    var viewModel: MovieSearchViewModel?
    var movies: [MovieModel] = []
    var delegate: MovieSearchViewControllerDelegate?
    var searchString: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}


// MARK: Private Functions

extension MovieSearchViewController {
    
    private func setupVC() {
        tableView.register(UINib(nibName: MovieSearchTableViewCell.cellNibName, bundle: .main), forCellReuseIdentifier: MovieSearchTableViewCell.reuseIdentifier)
        
        let viewModel               = MovieSearchViewModel()
        self.viewModel              = viewModel
        self.viewModel?.delegate    = self
    }
    
    private func moveToDetails(with movie: MovieModel) {
        self.dismiss(animated: true) {
            self.delegate?.moveToMovieDetails(with: movie)
        }
    }
    
    private func createSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center  = footerView.center
        spinner.color   = .systemGray3
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}


// MARK: View Model Delegate

extension MovieSearchViewController: MovieSearchViewModelDelegate {
    
    func searchReturned(with movies: [MovieModel]) {
        self.movies.append(contentsOf: movies)
        self.tableView.tableFooterView = nil
        if self.movies.count == 0 {
            let alert = UIAlertController(title: "Not Found", message: "Add a few more characters to refine search", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            tableView.reloadData()
        }
    }
}


// MARK: UIScrollView Delegate

extension MovieSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
            guard !(self.viewModel?.isPaginating ?? false) else {
                return
            }
            self.tableView.tableFooterView = createSpinner()
            self.viewModel?.searchMovies(with: searchString)
        }
    }
}


// MARK: Table View Delegate and Data Source

extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieSearchTableViewCell.reuseIdentifier, for: indexPath) as! MovieSearchTableViewCell
        
        cell.mainImageView.sd_setImage(with: URL(string: movies[indexPath.item].Poster), placeholderImage: UIImage(named: "placeholder.png"))
        cell.mainTitleLabel.text        = movies[indexPath.item].Title
        cell.mainDescriptionLabel.text  = "\(movies[indexPath.item].MovieType), \(movies[indexPath.item].Year)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveToDetails(with: movies[indexPath.item])
    }
}


// MARK: Search Bar Delegate

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 >= 3 {
            searchString = searchBar.text!
            self.viewModel?.searchMovies(with: searchString)
            searchBar.resignFirstResponder()
        }
        else {
            let alert = UIAlertController(title: "Number of Characters", message: "Add a few more characters to refine search", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
