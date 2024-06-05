//
//  MovieModel.swift
//  MRMovie
//
//  Created by fts on 26/05/2024.
//

struct MovieModel: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let rating: RatingModel?
    let image: MovieImageModel?
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
