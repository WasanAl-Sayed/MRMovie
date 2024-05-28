//
//  MoviesListViewModel.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MoviesListViewModel {
    
    // MARK: - Data Binding Callbacks
    
    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private(set) var moviesList: [MovieModel] = []
    private var page = 1
    private var isLoading = false
    
    var isInternetConnected: Bool {
        NetworkMonitor.shared.isConnected
    }
    
    // MARK: - Methods
    
    func fetchMovies(page: Int = 1) {
        guard !isLoading else { return }
        self.page = page
        isLoading = true
        
        Task {
            do {
                let movies = try await Client.fetchMovies(page: page)
                self.moviesList += movies
                self.isLoading = false
                onDataFetched?()
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
                onShowError?(Constants.errorMessage)
            }
        }
    }
    
    func fetchNextPage() {
        guard !isLoading else { return }
        fetchMovies(page: page + 1)
    }
    
    func loadMovies() {if isInternetConnected {
            fetchMovies()
        } else {
            onShowError?(Constants.alertMessage)
        }
    }
}
