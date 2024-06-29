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
    var onSearch: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private(set) var moviesList: [MovieModel] = []
    private(set) var moviesListCellUIModel: [MovieCellUIModel] = []
    private(set) var isLoading = false
    private(set) var isSearching = false
    private var page = 1
    
    // MARK: - Methods
    
    private func mapMoviesToCellUIModels() {
        moviesListCellUIModel = moviesList.map { movie in
            MovieCellUIModel(
                movieImage: movie.image?.medium ?? "",
                movieName: movie.name ?? "",
                movieType: movie.type ?? "",
                movieRating: movie.rating?.average ?? 0.0
            )
        }
    }
    
    private func parseError(_ errorDescription: String) -> String {
        let components = errorDescription.split(separator: ":").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return components.last ?? errorDescription
    }
    
    func fetchMovies(page: Int = 1) {
        guard !isLoading else { return }
        self.page = page
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            do {
                moviesList += try await MovieClient.fetchMovies(page: page)
                mapMoviesToCellUIModels()
                onDataFetched?()
            } catch {
                let errorMessage = parseError(error.localizedDescription)
                onShowError?(errorMessage)
            }
        }
    }
    
    func fetchNextPage() {
        fetchMovies(page: page + 1)
    }
    
    func searchMovies(name: String) {
        guard !isLoading else { return }
        
        guard !name.isEmpty else {
            isSearching = false
            moviesList.removeAll()
            moviesListCellUIModel.removeAll()
            fetchMovies()
            return
        }
        
        isSearching = true
        isLoading = true
        
        Task {
            defer {
                isLoading = false
            }
            do {
                let searchList = try await MovieClient.searchMovies(name: name)
                moviesList = searchList.map{ $0.show }
                mapMoviesToCellUIModels()
                onSearch?()
            } catch {
                let errorMessage = parseError(error.localizedDescription)
                onShowError?(errorMessage)
            }
        }
    }
}
