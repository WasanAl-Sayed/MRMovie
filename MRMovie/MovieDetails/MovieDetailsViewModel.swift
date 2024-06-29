//
//  MovieDetailsViewModel.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

class MovieDetailsViewModel {
    
    // MARK: - Data Binding Callbacks
    
    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private var movieId: Int
    private(set) var movieName: String
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
    
    private func createSectionData(movieDetails: MovieDetailsModel) {
        // Cover Image Section
        let coverImageSection = SectionData(
            type: Constants.coverType,
            title: Constants.coverTitle,
            footer: Constants.coverFooter,
            cellInfo: [DetailsCellUIModel(info: "", image: movieDetails.image?.original ?? "")]
        )
        sections.append(coverImageSection)
        
        // Details Sections
        let detailsSections: [SectionData] = [
            SectionData(
                type: Constants.infoType,
                title: Constants.nameTitle,
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.name ?? "", image: Constants.nameImage)]
            ),
            SectionData(
                type: Constants.infoType,
                title: Constants.typeTitle,
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.type ?? "", image: Constants.typeImage)]
            ),
            SectionData(
                type: Constants.infoType,
                title: Constants.scoreTitle,
                footer: Constants.scoreFooter,
                cellInfo: [DetailsCellUIModel(info: "\(movieDetails.weight ?? 0)", image: Constants.scoreImage)]
            ),
            SectionData(
                type: Constants.infoType,
                title: Constants.genresTitle,
                footer: Constants.genresFooter,
                cellInfo: [DetailsCellUIModel(info: movieDetails.genres?.joined(separator: ", ") ?? "", image: Constants.genresImage)]
            ),
            SectionData(
                type: Constants.infoType,
                title: Constants.statusTitle,
                footer: "",
                cellInfo: [DetailsCellUIModel(info: movieDetails.status ?? "", image: Constants.statusImage)]
            ),
            SectionData(
                type: Constants.infoType,
                title: Constants.scheduleTitle,
                footer: Constants.timeDayFooter,
                cellInfo: [
                    DetailsCellUIModel(info: movieDetails.schedule?.time ?? "", image: Constants.timeImage),
                    DetailsCellUIModel(info: movieDetails.schedule?.days.joined(separator: ", ") ?? "", image: Constants.dayImage)
                ]
            )
        ]
        sections.append(contentsOf: detailsSections)
    }
    
    public func fetchMovieDetails() {
        Task {
            do {
                let movieDetails = try await MovieClient.fetchMovieDetails(id: movieId)
                createSectionData(movieDetails: movieDetails)
                onDataFetched?()
            } catch {
                let errorMessage = parseError(error.localizedDescription)
                onShowError?(errorMessage)
            }
        }
    }
}

