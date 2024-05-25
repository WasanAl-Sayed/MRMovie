//
//  MovieTableViewCell.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    
    // MARK: - Properties
    
    static var identifier = Constants.movieCell

    // MARK: - Setup Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.movieCell, bundle: nil)
    }
    
    // MARK: - Helper Methods
    
    private func configureViews() {
        movieImageView.layer.cornerRadius = 10
    }
}
