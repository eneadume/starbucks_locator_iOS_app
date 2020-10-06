//
//  StoresTableViewController.swift
//  Starbucks
//
//  Created by User on 4/27/19.
//  Copyright © 2019 Enea Dume. All rights reserved.
//

import UIKit

class StoresTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    
    var results: Results?
    var searchedResults = [Store]()
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()
        //used these to set automaticly the row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        //get all stores
        getStores()
    }
    
    
    /**
     get all stores
     */
    func getStores() {
        guard let url = URL(string: LOCAL_STORES_URL) else { return }
        StoresService.getLocalStores(url) { [weak self] results,error  in
            //check if there is an error from request
            if error != nil {
                self?.showServerError(error: error!)
            }else {
                self?.results = results
                self?.tableView.reloadData()
                //remove the animation view
                UIView.animate(withDuration: 0.4, animations: {
                    self?.animationView.alpha = 0
                })
            }
        }
    }
    

    /**
     show the error messagges of server during requests
     */
     func showServerError(error: Error){
        let alertController = UIAlertController(title: "Attention", message: error.localizedDescription, preferredStyle: .alert)
        //if there is an error in request show an alert and suggest to try again
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self](action) in
           self?.getStores()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     create a searchController
     */
    func addSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Address"
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /**
     filter stores according address
     - parameters: searchController: UISearchController
     */
    func filterStore(_ searchController: UISearchController) {
        //get search text and check if it is not empty
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            guard let stores = results?.results else { return }
            //filter store according store address
            searchedResults = StoresService.getFilteredStores(stores: stores, searchText: searchText)
            isSearching = true
        }else {
            isSearching = false
            searchedResults = [Store]()
        }
        
        tableView.reloadData()
    }
    
}


extension StoresTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedResults.count : results?.results.count ?? 0
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreListTableViewCell.reuseIdentifier, for: indexPath) as? StoreListTableViewCell ?? StoreListTableViewCell()
        //if user is making a search the store will be taken from searchedResult not from api results
        if let store = isSearching ? searchedResults[indexPath.row] : results?.results[indexPath.row] {
            cell.setStore(store: store)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let store = isSearching ? searchedResults[indexPath.row] : results?.results[indexPath.row] {
            //instatiate MapViewController
            guard let mapViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
            //assign a store to mapViewController store object
            mapViewController.store = store
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    //used to remove the lines in the end of tableView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension StoresTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterStore(searchController)
    }
    
    
}
