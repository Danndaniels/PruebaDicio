//
//  UsersSearch.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import Foundation

struct UsersSearch: Codable {
    let results: [UserItem]?
}

public struct UserItem: Codable {
    let idUser: Int?
    let nombre, apellidoPaterno , apellidoMaterno, email, fechaNac: String
    let edad: Int
    
    let datos: DataItem?
    
    enum CodingKeys: String, CodingKey {
        case nombre, apellidoPaterno, apellidoMaterno, email, fechaNac
        case idUser = "id"
        case edad
        case datos
    }
}

struct DataItem: Codable {
    let calle, colonia , cp, delegacion: String?
    let estado, imagen, numero: String?

    
    enum CodingKeys: String, CodingKey {
        case calle, colonia, cp, delegacion
        case estado, imagen, numero
    }
 
}

// MARK: Convenience initializers

extension UsersSearch {
    init(data: Data) throws {
        self.results = try JSONDecoder().decode([UserItem].self, from: data)
    }
}
