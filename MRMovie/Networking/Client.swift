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
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        decode: @escaping (Data) throws -> T
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers,
                interceptor: nil
            )
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
        let url = "\(Constants.url)\(page)"
        return try await performRequest(
            url: url,
            method: .get,
            decode: decodeResponse
        )
    }

    static func searchMovies(name: String) async throws -> [MovieModel] {
        let url = "\(Constants.searchURL)\(name)"
        return try await performRequest(
            url: url,
            method: .get,
            decode: { data in
                let searchResults: [SearchResultModel] = try decodeResponse(data)
                return searchResults.map { $0.show }
            }
        )
    }
}
