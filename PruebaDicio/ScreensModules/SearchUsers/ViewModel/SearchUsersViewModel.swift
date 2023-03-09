//
//  SearchUsersViewModel.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import Foundation

class SearchUsersViewModel{
    // dependency injection
    private let apiManager = APIManager.shared
    
    // search result Data source for TableView Display
    
    var searhResults = [UserItemRepresentable]()
    var filteredSearhResults = [UserItemRepresentable]()

    var searchInput: String = "" {
        didSet{
            // start fetch after 3 character
            if searchInput.count > 2{
                //self.performSearch()
            }
        }
    }

    var didFetchResult: (_ result:[UserItemRepresentable]) -> (Void) = { _  in }
    
    var didStartFetch: () -> (Void) = {   }

    var searchFetchError: ( _ error:Error?) -> (Void) = { _ in  }

    
    //MARK: API Search
    func performSearch(){
        didStartFetch()
        apiManager.request(DicioAPI.get, succes: { (data) in
           if let user = try? UsersSearch.init(data: data),
            let items = user.results {
            let cellReprecentable = items.map({UserItemCellViewModel($0)})
            self.searhResults = cellReprecentable
            self.didFetchResult(cellReprecentable)
            }
        }) { (result, error) in
            self.searchFetchError(error)
        }
        
    }
}
