//
//  RoomTableViewCell.swift
//  SocketIoSwift
//
//  Created by somsak on 24/6/2564 BE.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
