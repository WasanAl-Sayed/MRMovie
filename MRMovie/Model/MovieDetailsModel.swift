//
//  MovieDetailsModel.swift
//  MRMovie
//
//  Created by fts on 11/06/2024.
//

struct MovieDetailsModel: Codable {
    let name: String?
    let type: String?
    let genres: [String]?
    let status: String?
    let schedule: ScheduleModel?
    let weight: Int?
    let image: MovieImageModel?
}

struct ScheduleModel: Codable {
    let time: String
    let days: [String]
}

struct SectionData {
    let type: String
    let title: String
    let footer: String
    let cellInfo: [DetailsCellUIModel]
}

struct DetailsCellUIModel {
    let info: String
    let image: String
}
