//
//  MovieSearchTableViewCell.swift
//  Movietastic
//
//  Created by Macbook Pro on 04/10/2020.
//

import UIKit

class MovieSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    
    static let reuseIdentifier = "movieSearchTableViewCell"
    static let cellNibName     = "MovieSearchTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
