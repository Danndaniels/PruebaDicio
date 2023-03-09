//
//  UpdateUserViewModel.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 08/03/23.
//

import Foundation

class UpdateUserViewModel{
    // dependency injection
    private let apiManager = APIManager.shared
    
    // curren user item
    var userItem : UserItemRepresentable?

    var didFetchResult: () -> (Void) = { }
    var didStartFetch: () -> (Void) = {   }
    var searchFetchError: ( _ error:Error?) -> (Void) = { _ in  }

    init(userItem item:UserItemRepresentable?) {
        self.userItem = item
    }
    
    //MARK: API Register User
    
    func performUpdate(user: UserItem){
        didStartFetch()
        self.didFetchResult()
        apiManager.request(DicioAPI.update(user: user), succes: { (data) in
           if let user = try? UsersSearch.init(data: data),
            let items = user.results {

            self.didFetchResult()
            }
        }) { (result, error) in
            self.searchFetchError(error)
        }
        
    }
}
