//
//  MovieModel.swift
//  MRMovie
//
//  Created by fts on 26/05/2024.
//

import UIKit

struct MovieModel: Codable {
    let id: Int
    let name: String
    let type: String
    let genres: [String]
    let status: String
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let image: MovieImage
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Rating: Codable {
    let average: Double?
}

struct MovieImage: Codable {
    let medium: String
    let original: String
}
