//
//  RegisterUserViewModel.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 08/03/23.
//

import Foundation

class RegisterUserViewModel{
    // dependency injection
    private let apiManager = APIManager.shared
    
    // search result Data source for TableView Display

    var didFetchResult: () -> (Void) = { }
    var didStartFetch: () -> (Void) = {   }
    var searchFetchError: ( _ error:Error?) -> (Void) = { _ in  }

    
    //MARK: API Register User
    
    func performRegister(user: UserItem){
        didStartFetch()
        self.didFetchResult()
        apiManager.request(DicioAPI.post(user: user), succes: { (data) in
           if let user = try? UsersSearch.init(data: data),
            let items = user.results {

            self.didFetchResult()
            }
        }) { (result, error) in
            self.searchFetchError(error)
        }
        
    }
}
