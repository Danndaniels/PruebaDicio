//
//  Extension+String.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 08/03/23.
//

import Foundation
import UIKit
extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidDate() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yy-MM-dd"
        if let _ = dateFormatterGet.date(from: self) {
            return true
        } else {
            // Invalid date
            return false
        }
    }
    
    func imageFromBase64() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}
