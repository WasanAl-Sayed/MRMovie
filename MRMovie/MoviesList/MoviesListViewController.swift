//
//  MoviesListViewController.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MoviesListViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var moviesTableview: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let viewModel = MoviesListViewModel()
    let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableview.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        bindViewModel()
        loadingIndicator.startAnimating()
        viewModel.loadMovies()
    }
    
    // MARK: - Helper Methods
    
    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.spinnerLoadingStatus(isLoading: false)
                self?.moviesTableview.reloadData()
            }
        }
        
        viewModel.onShowError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.spinnerLoadingStatus(isLoading: false)
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func configureSpinner() {
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: moviesTableview.bounds.width,
            height: CGFloat(30)
        )
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: Constants.alertTitle,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Constants.alertButton, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func spinnerLoadingStatus(isLoading: Bool) {
        if isLoading {
            spinner.startAnimating()
            moviesTableview.tableFooterView?.isHidden = false
        } else {
            spinner.stopAnimating()
            moviesTableview.tableFooterView?.isHidden = true
        }
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.moviesList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = moviesTableview.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell
        
        let movieModel = viewModel.moviesList[indexPath.item]
        let cellUIModel = MovieCellUIModel(
            movieImage: movieModel.image.medium,
            movieName: movieModel.name,
            movieType: movieModel.type,
            movieRating: movieModel.rating.average ?? 0.0
        )
        cell?.configureCell(cellUIModel: cellUIModel)
        
        return cell ?? MovieTableViewCell()
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            configureSpinner()
            moviesTableview.tableFooterView = spinner
            spinnerLoadingStatus(isLoading: true)
            viewModel.fetchNextPage()
        }
    }
}
