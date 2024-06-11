//
//  MovieDetailsViewController.swift
//  MRMovie
//
//  Created by fts on 25/05/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var movieDetailsTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var viewModel: MovieDetailsViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        viewModel?.fetchMovieDetails()
    }
    
    // MARK: - Helper Methods
    
    private func configureViews() {
        self.title = viewModel?.movieName
        configureMovieDetailsTableView()
        loadingIndicator.startAnimating()
    }
    
    private func configureMovieDetailsTableView() {
        movieDetailsTableView.isHidden = true
        movieDetailsTableView.register(DetailsTableViewCell.nib(), forCellReuseIdentifier: DetailsTableViewCell.identifier)
        movieDetailsTableView.register(CoverImageTableViewCell.nib(), forCellReuseIdentifier: CoverImageTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel?.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.movieDetailsTableView.isHidden = false
                self?.viewModel?.createSectionData()
                self?.movieDetailsTableView.reloadData()
            }
        }
        
        viewModel?.onShowError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
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
}

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel?.sections[section].cellInfo.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cellInfo = viewModel?.sections[indexPath.section].cellInfo[indexPath.row] else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let cell = movieDetailsTableView.dequeueReusableCell(
                withIdentifier: CoverImageTableViewCell.identifier,
                for: indexPath
            ) as? CoverImageTableViewCell
            cell?.configureCell(image: cellInfo.image)
            return cell ?? UITableViewCell()
        } else {
            let cell = movieDetailsTableView.dequeueReusableCell(
                withIdentifier: DetailsTableViewCell.identifier,
                for: indexPath
            ) as? DetailsTableViewCell
            
            cell?.configureCell(cellInfo: cellInfo)
            
            return cell ?? UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return viewModel?.sections[section].title
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        return viewModel?.sections[section].footer
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 20
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return 50
        }
    }
}
