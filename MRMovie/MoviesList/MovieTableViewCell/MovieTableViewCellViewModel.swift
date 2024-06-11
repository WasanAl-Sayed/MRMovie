//
//  MovieTableViewCellViewModel.swift
//  MRMovie
//
//  Created by fts on 01/06/2024.
//

import UIKit

class MovieTableViewCellViewModel {
    
    // MARK: - Methods
    
    func getStarImages(for rating: Double) -> [UIImage?] {
        let finalRate = rating / 2
        let fullStars = Int(finalRate)
        let halfStar = finalRate - Double(fullStars) >= 0.5
        
        return (0..<5).map { index in
            if index < fullStars {
                return UIImage(systemName: "star.fill")
            } else if index == fullStars && halfStar {
                return UIImage(systemName: "star.leadinghalf.fill")
            } else {
                return UIImage(systemName: "star")
            }
        }
    }
}
