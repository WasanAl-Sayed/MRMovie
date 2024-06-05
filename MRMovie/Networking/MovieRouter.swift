//
//  MovieRouter.swift
//  MRMovie
//
//  Created by fts on 04/06/2024.
//

import UIKit
import Alamofire

enum MovieRouter: URLRequestConvertible {
    
    // MARK: - Endpoints
    
    case fetchMovies(page: Int)
    case searchMovies(name: String)
    
    // MARK: - Paths
    
    var path: String {
        switch self {
        case .fetchMovies(let page):
            return Constants.url
        case .searchMovies(let name):
            return Constants.searchURL
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
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
