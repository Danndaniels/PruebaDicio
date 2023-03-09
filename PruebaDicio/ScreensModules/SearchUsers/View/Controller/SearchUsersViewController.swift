//
//  ViewController.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import UIKit

class SearchUsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    internal  var searchViewModel = SearchUsersViewModel()
    
    
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupConfig()
        self.initViewModel()
        self.searchViewModel.performSearch()
    }
    
    
    //MARK:- Inital SubViews
    func setupConfig(){

        self.tableView.alpha = 0
        self.navigationItem.title = "Dicio"
        searchController.searchBar.placeholder = "Busqueda por nombre"
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, we place the search bar in the navigation bar.
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            // We want the search bar visible all the time.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, we place the search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true

        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    
    //MARK:- Initalized ViewModel
    
    func initViewModel(){
        
        searchViewModel.didFetchResult = { [weak self]  (result)  in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                strongSelf.searchViewModel.searhResults = result
                strongSelf.tableView.alpha = 1
                strongSelf.tableView.reloadData()
            }
        }
        
        searchViewModel.didStartFetch = { [weak self] in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                strongSelf.tableView.alpha = 0
            }
        }
        
        searchViewModel.searchFetchError = { [weak self] (error)in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                guard let error = error else {return}
                strongSelf.tableView.alpha = 0
            }
        }
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? UpdateUserController,
          let userItem = sender as? UserItemRepresentable  {
            let updateViewModel = UpdateUserViewModel(userItem: userItem)
            destination.updateUserViewModel = updateViewModel
        }
    }
   
}

  //MARK:- TableView Delegate
extension SearchUsersViewController : UITableViewDelegate,UITableViewDataSource{
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.searchViewModel.filteredSearhResults.count
        }
        return self.searchViewModel.searhResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userItem = self.searchViewModel.searhResults[indexPath.row]
        
        self.performSegue(withIdentifier: "updateUserIdentifier", sender: userItem)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserItemViewCell.cellIdentifier, for: indexPath) as!  UserItemViewCell
        if isFiltering {
            cell.userItem = self.searchViewModel.filteredSearhResults[indexPath.row]
        } else {
            cell.userItem = self.searchViewModel.searhResults[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchUsersViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchViewModel.searchInput = searchText
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.searchViewModel.filteredSearhResults = self.searchViewModel.searhResults.filter { (user: UserItemRepresentable) -> Bool in
    
        
            return user.userName.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

extension SearchUsersViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)
    }
}


