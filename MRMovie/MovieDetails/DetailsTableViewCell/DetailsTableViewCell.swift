//
//  DetailsTableViewCell.swift
//  MRMovie
//
//  Created by fts on 11/06/2024.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    // MARK: - Properties
    
    static var identifier = Constants.detailsCell

    // MARK: - Setup Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.detailsCell, bundle: nil)
    }
    
    // MARK: - Helper Methods
    
    public func configureCell(cellInfo: DetailsCellUIModel) {
        infoLabel.text = cellInfo.info
        cellImage.image = UIImage(named: cellInfo.image)
    }
}
