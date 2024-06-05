//
//  BaseClient.swift
//  MRMovie
//
//  Created by fts on 05/06/2024.
//

import Foundation
import Alamofire

class BaseClient {
    
    // MARK: - Methods
    
    static func performRequest<T: Decodable>(
        router: URLRequestConvertible
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let result):
                        continuation.resume(returning: result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
