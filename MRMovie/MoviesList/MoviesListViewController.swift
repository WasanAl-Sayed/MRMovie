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
    @IBOutlet weak var emptyResultLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    private let viewModel = MoviesListViewModel()
    let footerView = TableViewFooter()
    private var searchTask: DispatchWorkItem?
    private var searchActivityIndicator: UIActivityIndicatorView?
    
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
        configureTableView()
        configureSearchBar()
        loadingIndicator.startAnimating()
    }
    
    private func configureTableFooter() {
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50)
        moviesTableview.tableFooterView = footerView
    }
    
    private func configureTableView() {
        moviesTableview.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        moviesTableview.register(TableViewFooter.nib(), forHeaderFooterViewReuseIdentifier: TableViewFooter.identifier)
    }
    
    private func configureSearchBar() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: searchBar.frame.height))
        activityIndicator.center = leftView.center
        leftView.addSubview(activityIndicator)
        
        searchBar.searchTextField.leftView = leftView
        searchBar.searchTextField.leftViewMode = .always
        
        self.searchActivityIndicator = activityIndicator
    }
    
    private func bindViewModel() {
        viewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.bindViewModelUpdates()
                self?.moviesTableview.reloadData()
            }
        }
        
        viewModel.onSearch = { [weak self] in
            DispatchQueue.main.async {
                self?.bindViewModelUpdates()
                self?.moviesTableview.reloadData()
            }
        }
        
        viewModel.onShowError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.bindViewModelUpdates()
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func bindViewModelUpdates() {
        loadingIndicator.stopAnimating()
        searchActivityIndicator?.stopAnimating()
        footerView.stopAnimating()
        emptyResultLabel.isHidden = !viewModel.moviesListCellUIModel.isEmpty
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
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    // MARK: - UITableViewDelegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !viewModel.isLoading && !viewModel.isSearching {
                footerView.startAnimating()
                viewModel.fetchNextPage()
            }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            let movieName = viewModel.moviesList[indexPath.item].name ?? ""
            let movieId = viewModel.moviesList[indexPath.item].id ?? 0
            let movieDetailsViewModel = MovieDetailsViewModel(movieName: movieName, movieId: movieId)
            movieDetailsVC.viewModel = movieDetailsViewModel
            navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        searchTask?.cancel()
        searchActivityIndicator?.startAnimating()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchMovies(name: searchText)
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
}
