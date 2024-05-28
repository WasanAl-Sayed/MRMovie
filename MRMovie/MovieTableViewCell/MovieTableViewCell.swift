//
//  MovieTableViewCell.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet var starsImageViews: [UIImageView]!
    
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
    
    private func configureRatingStars(rate: Double) {
        let finalRate = rate / 2
        let fullStars = Int(finalRate)
        let halfStar = finalRate - Double(fullStars) >= 0.5
        
        for (index, starImageView) in starsImageViews.enumerated() {
            if index < fullStars {
                starImageView.image = UIImage(systemName: "star.fill")
            } else if index == fullStars && halfStar {
                starImageView.image = UIImage(systemName: "star.leadinghalf.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
    }
    
    public func configureCell(cellUIModel: MovieCellUIModel) {
        movieNameLabel.text = cellUIModel.movieName
        movieTypeLabel.text = cellUIModel.movieType
        let url = URL(string: cellUIModel.movieImage)
        movieImageView.kf.setImage(with: url)
        configureRatingStars(rate: cellUIModel.movieRating)
    }
}
