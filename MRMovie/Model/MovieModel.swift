//
//  MovieModel.swift
//  MRMovie
//
//  Created by fts on 26/05/2024.
//

import UIKit

struct MovieModel: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let genres: [String]?
    let status: String?
    let schedule: ScheduleModel?
    let rating: RatingModel?
    let weight: Int?
    let image: MovieImageModel?
}

struct ScheduleModel: Codable {
    let time: String
    let days: [String]
}

struct RatingModel: Codable {
    let average: Double?
}

struct MovieImageModel: Codable {
    let medium: String
    let original: String
}

struct SearchResultModel: Codable {
    let show: MovieModel
}
