//
//  TableViewFooter.swift
//  MRMovie
//
//  Created by fts on 02/06/2024.
//

import UIKit

class TableViewFooter: UITableViewHeaderFooterView {
    
    // MARK: - Properties

    static let identifier = "TableViewFooter"
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Setup Methods
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    // MARK: - Helper Methods
    
    private func setupViews() {
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        spinner.startAnimating()
        self.isHidden = false
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
        self.isHidden = true
    }
}
