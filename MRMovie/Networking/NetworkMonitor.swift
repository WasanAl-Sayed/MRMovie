//
//  NetworkMonitor.swift
//  MRMovie
//
//  Created by fts on 26/05/2024.
//

import UIKit
import Network

final class NetworkMonitor {
    
    // MARK: - Properties
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    
    static let shared = NetworkMonitor()
    
    // MARK: - Initializer
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // MARK: - Helper Methods
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
}
