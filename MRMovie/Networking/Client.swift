//
//  Client.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit
import Alamofire

class Client {

    // MARK: - Methods

    static func performRequest<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        decode: @escaping (Data) throws -> T
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil,
                interceptor: nil
            )
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try decode(data!)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    static func fetchMovies(page: Int) async throws -> [MovieModel] {
        let url = "\(Constants.url)\(page)"
        return try await performRequest(
            url: url,
            method: .get,
            parameters: nil
        ) { data in
            return try JSONDecoder().decode([MovieModel].self, from: data)
        }
    }

    static func searchMovies(name: String) async throws -> [MovieModel] {
        let url = "\(Constants.searchURL)\(name)"
        return try await performRequest(
            url: url,
            method: .get,
            parameters: nil
        ) { data in
            let searchResults = try JSONDecoder().decode([SearchResultModel].self, from: data)
            return searchResults.map { $0.show }
        }
    }
}
