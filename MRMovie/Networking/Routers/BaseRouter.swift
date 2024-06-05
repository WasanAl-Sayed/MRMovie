//
//  BaseRouter.swift
//  MRMovie
//
//  Created by fts on 05/06/2024.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

extension BaseRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
