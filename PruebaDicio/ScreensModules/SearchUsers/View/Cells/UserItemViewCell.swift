//
//  UserItemViewCell.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import Foundation
import UIKit

class UserItemViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userEmailLbl: UILabel!
    
    // MARK: - Types
    static let nibName = "UserItemViewCell"
    static let cellIdentifier = "UserItemViewCell"
    
    
    var userItem: UserItemRepresentable? {
        didSet{
            self.userNameLbl.text = userItem?.userName
            self.userEmailLbl.text = userItem?.userEmail
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
