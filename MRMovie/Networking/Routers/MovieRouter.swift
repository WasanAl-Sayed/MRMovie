//
//  MovieRouter.swift
//  MRMovie
//
//  Created by fts on 04/06/2024.
//

import Foundation
import Alamofire

enum MovieRouter: BaseRouter {
    
    // MARK: - Endpoints
    
    case fetchMovies(page: Int)
    case searchMovies(name: String)
    
    // MARK: - Paths
    
    var path: String {
        switch self {
        case .fetchMovies:
            return "/shows"
        case .searchMovies:
            return "/search/shows"
        }
    }
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovies, .searchMovies:
            return .get
        }
    }
    
    // MARK: - Parameters
    
    var parameters: Parameters? {
        switch self {
        case .fetchMovies(let page):
            return ["page": page]
        case .searchMovies(let name):
            return ["q": name]
        }
    }
}
