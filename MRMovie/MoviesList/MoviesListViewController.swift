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
    private var searchTask: DispatchWorkItem?
    let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        viewModel.fetchMovies()
    }
    
    // MARK: - Helper Methods
    
    private func configureViews() {
        configureTableFooter()
        moviesTableview.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        loadingIndicator.startAnimating()
    }
    
    private func configureTableFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        moviesTableview.tableFooterView = footerView
    }
    
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
    
    private func showAlert(title: String = Constants.alertTitle, message: String) {
        let alertController = UIAlertController(
            title: title,
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

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.moviesListCellUIModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = moviesTableview.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell
        
        let cellUIModel = viewModel.moviesListCellUIModel[indexPath.item]
        cell?.configureCell(cellUIModel: cellUIModel)
        
        return cell ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !viewModel.isLoading && !viewModel.isSearching {
                spinnerLoadingStatus(isLoading: true)
                viewModel.fetchNextPage()
            }
        }
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchMovies(name: searchText)
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
}
