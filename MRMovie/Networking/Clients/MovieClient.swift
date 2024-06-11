//
//  MovieClient.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MovieClient: BaseClient {

    // MARK: - Methods
    
    static func fetchMovies(page: Int) async throws -> [MovieModel] {
        let router = MovieRouter.fetchMovies(page: page)
        return try await performRequest(router: router)
    }

    static func searchMovies(name: String) async throws -> [SearchResultModel] {
        let router = MovieRouter.searchMovies(name: name)
        return try await performRequest(router: router)
    }
    
    static func fetchMovieDetails(id: Int) async throws -> MovieDetailsModel {
        let router = MovieRouter.movieDetails(id: id)
        return try await performRequest(router: router)
    }
}
