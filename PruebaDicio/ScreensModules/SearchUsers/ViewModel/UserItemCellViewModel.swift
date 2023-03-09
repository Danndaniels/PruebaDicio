//
//  UserItemCellViewModel.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import Foundation
import Foundation

protocol UserItemRepresentable {
    var userName :String {get}
    var userFirstName :String {get}
    var userSecondName :String {get}
    var userEmail :String {get}
    var userDate :String {get}
    var userStreet :String {get}
    var userNumberStree :String {get}
    var userColony :String {get}
    var userMunicipality :String {get}
    var userState :String {get}
    var userCP :String {get}
    var userImage  :String  {get}
}


class UserItemCellViewModel: UserItemRepresentable {
    
    private var userItem:UserItem
    
    init(_ userItem:UserItem) {
        
        self.userItem = userItem
    }
    
    var userName: String {
        return self.userItem.nombre
    }
    
    var userFirstName: String{
        return self.userItem.apellidoPaterno
    }
    
    var userSecondName: String{
        return self.userItem.apellidoMaterno
    }
    
    var userDate: String{
        return self.userItem.fechaNac
    }
    
    var userStreet: String{
        return self.userItem.datos?.calle ?? ""
    }
    
    var userNumberStree: String{
        return self.userItem.datos?.numero ?? ""
    }
    
    var userColony: String{
        return self.userItem.datos?.colonia ?? ""
    }
    
    var userMunicipality: String{
        return self.userItem.datos?.delegacion ?? ""
    }
    
    var userState: String{
        return self.userItem.datos?.estado ?? ""
    }
    
    var userCP: String{
        return self.userItem.datos?.cp ?? ""
    }
    
    var userEmail: String {
        return self.userItem.email
    }
    
    var userImage: String {
        return self.userItem.datos?.imagen ?? ""
    }
}
