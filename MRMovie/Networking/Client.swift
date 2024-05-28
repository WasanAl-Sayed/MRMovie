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
    
    static func fetchMovies(page: Int) async throws -> [MovieModel] {
        let url = "\(Constants.url)\(page)"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: nil,
                interceptor: nil
            )
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let moviesList = try JSONDecoder().decode([MovieModel].self, from: data!)
                        continuation.resume(returning: moviesList)
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
