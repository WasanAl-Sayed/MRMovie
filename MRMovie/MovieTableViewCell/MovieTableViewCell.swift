//
//  MovieTableViewCell.swift
//  MRMovie
//
//  Created by fts on 23/05/2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    // MARK: - Properties
    
    static let identifier = "MovieTableViewCell"
    
    // MARK: - Setup Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
}
