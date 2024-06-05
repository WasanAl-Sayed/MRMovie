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
        router: URLRequestConvertible,
        decode: @escaping (Data) throws -> T
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router)
                .response { response in
                    switch response.result {
                    case .success(let data):
                        guard let data = data else {
                            continuation.resume(
                                throwing: NSError(
                                    domain: "ClientErrorDomain",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data received"]
                                )
                            )
                            return
                        }
                        do {
                            let result = try decode(data)
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
    
    private static func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

    static func fetchMovies(page: Int) async throws -> [MovieModel] {
        return try await performRequest(
            router: MovieRouter.fetchMovies(page: page),
            decode: decodeResponse
        )
    }

    static func searchMovies(name: String) async throws -> [MovieModel] {
        return try await performRequest(
            router: MovieRouter.searchMovies(name: name),
            decode: { data in
                let searchResults: [SearchResultModel] = try decodeResponse(data)
                return searchResults.map { $0.show }
            }
        )
    }
}
