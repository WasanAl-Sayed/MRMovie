//
//  CoverImageTableViewCell.swift
//  MRMovie
//
//  Created by fts on 11/06/2024.
//

import UIKit
import Kingfisher

class CoverImageTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    static var identifier = Constants.coverImageCell
    
    // MARK: - Setup Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.coverImageCell, bundle: nil)
    }
    
    // MARK: - Helper Methods
    
    public func configureCell(image: String) {
        let url = URL(string: image)
        loadingIndicator.startAnimating()
        coverImage.kf.setImage(with: url, completionHandler: { [weak self] _ in
            self?.loadingIndicator.stopAnimating()
        })
    }
}
