//
//  StoreViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StoreViewController: UIViewController {

    private let cellID = "\(ProductCell.self)"
    private var products: [Product] = [Product(image: #imageLiteral(resourceName: "HubbaBubba"), name: "HubbaBubba"),
                                       Product(image: #imageLiteral(resourceName: "Parker"), name: "Parker"),
                                       Product(image: #imageLiteral(resourceName: "IWC"), name: "IWC Schaffhausen")]
    
     private var searchedProducts: [Product] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupNavigationBar()
        setupKeyboard()
        setupCollectionView()
        setupRefreshControl()
        setupSearchController()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Магазин"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let image = UIImage(systemName: "cart")
        let cartButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: nil)
        navigationItem.rightBarButtonItem = cartButton
    }
    
    private func setupKeyboard() {
        collectionView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func filterContent(for searchText: String) {
        searchedProducts = products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @objc private func refresh() {
        refreshControl.endRefreshing()
    }
}




// MARK: - UICollectionViewDataSource

extension StoreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchController.isActive ? searchedProducts.count : 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProductCell
        
        let index = indexPath.row % 3
        let product = searchController.isActive ? searchedProducts[indexPath.row] : products[index]
        
        cell.imageView.image = product.image
        cell.label.text = product.name
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension StoreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row % 3
        let product = searchController.isActive ? searchedProducts[indexPath.row] : products[index]
        
        let vc = ProductViewController(product: product)
        navigationController?.pushViewController(vc, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}




// MARK: - UISearchResultsUpdating

extension StoreViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContent(for: searchText)
        collectionView.reloadData()
    }
}
