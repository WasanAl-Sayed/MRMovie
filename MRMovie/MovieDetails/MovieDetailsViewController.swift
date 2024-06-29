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
        movieDetailsTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
    }
    
    private func bindViewModel() {
        viewModel?.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.movieDetailsTableView.isHidden = false
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
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
        
        guard let sectionInfo = viewModel?.sections[indexPath.section] else { return UITableViewCell() }
        let cellInfo = sectionInfo.cellInfo[indexPath.row]
        
        if sectionInfo.type == "cover" {
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
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let title = viewModel?.sections[section].title else { return nil }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifier) as! CustomHeaderView
        headerView.configure(with: title)
        return headerView
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        guard let footer = viewModel?.sections[section].footer else { return nil }
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifier) as! CustomHeaderView
        footerView.configure(with: footer)
        return footerView
    }
    
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
        return 25
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return 50
        }
    }
}
