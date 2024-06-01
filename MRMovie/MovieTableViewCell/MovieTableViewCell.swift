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
    private let cellViewModel = MovieTableViewCellViewModel()

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
    
    private func configureRatingStars(rating: Double) {
        let starImages = cellViewModel.getStarImages(for: rating)
        
        zip(starsImageViews, starImages).forEach { imageView, image in
            imageView.image = image
        }
    }
    
    public func configureCell(cellUIModel: MovieCellUIModel) {
        movieNameLabel.text = cellUIModel.movieName
        movieTypeLabel.text = cellUIModel.movieType
        let url = URL(string: cellUIModel.movieImage)
        movieImageView.kf.setImage(with: url)
        configureRatingStars(rating: cellUIModel.movieRating)
    }
}
