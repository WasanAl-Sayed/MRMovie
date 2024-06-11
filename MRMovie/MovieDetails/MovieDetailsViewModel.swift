//
//  MovieDetailsViewModel.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MovieDetailsViewModel {
    
    // MARK: - Data Binding Callbacks
    
    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private(set) var movieName: String
    private(set) var movieId: Int
    private(set) var movieDetails: MovieDetailsModel?
    private(set) var sections: [SectionData] = []
    
    // MARK: - Initializer
    
    init(movieName: String, movieId: Int) {
        self.movieName = movieName
        self.movieId = movieId
    }
    
    // MARK: - Methods
    
    private func parseError(_ errorDescription: String) -> String {
        let components = errorDescription.split(separator: ":").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        return components.last ?? errorDescription
    }
    
    public func fetchMovieDetails() {
        Task {
            do {
                movieDetails = try await MovieClient.fetchMovieDetails(id: movieId)
                onDataFetched?()
            } catch {
                let errorMessage = parseError(error.localizedDescription)
                onShowError?(errorMessage)
            }
        }
    }
    
    public func createSectionData() {
        guard let movieDetails = movieDetails else { return }
        
        // Cover Image Section
        let coverImageSection = SectionData(
            title: "COVER PHOTO",
            footer: "This photo should be a landscape to fit the cover",
            cellInfo: [DetailsCellUIModel(info: "", image: movieDetails.image?.original ?? "")]
        )
        sections.append(coverImageSection)
        
        // Details Sections
        let detailsSections: [SectionData] = [
            SectionData(
                title: "NAME",
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.name ?? "", image: Constants.images[0])]
            ),
            SectionData(
                title: "TYPE",
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.type ?? "", image: Constants.images[1])]
            ),
            SectionData(
                title: "SCORE",
                footer: "The number of points",
                cellInfo: [DetailsCellUIModel(info: "\(movieDetails.weight ?? 0)", image: Constants.images[2])]
            ),
            SectionData(
                title: "GENRES",
                footer: "A category of artistic composition",
                cellInfo: [DetailsCellUIModel(info: movieDetails.genres?.joined(separator: ", ") ?? "", image: Constants.images[3])]
            ),
            SectionData(
                title: "STATUS",
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.status ?? "", image: Constants.images[4])]
            ),
            SectionData(
                title: "SCHEDULE",
                footer: "Time and Date that movie will show",
                cellInfo: [
                    DetailsCellUIModel(info: movieDetails.schedule?.time ?? "", image: Constants.images[5]),
                    DetailsCellUIModel(info: movieDetails.schedule?.days.joined(separator: ", ") ?? "", image: Constants.images[6])
                ]
            )
        ]
        sections.append(contentsOf: detailsSections)
    }
}

