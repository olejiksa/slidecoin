//
//  PurchasesViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PurchasesViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchController()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Покупки"
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
}




// MARK: - UISearchResultsUpdating

extension PurchasesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else { return }
//        filterContent(for: searchText)
//        collectionView.reloadData()
    }
}
