//
//  MovieListCollectionViewCell.swift
//  Movietastic
//
//  Created by Macbook Pro on 03/10/2020.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    static let reuseIdentifier = "movieListCollectionViewCell"
    static let cellNibName     = "MovieListCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
