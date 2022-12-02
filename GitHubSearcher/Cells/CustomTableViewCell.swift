//
//  CustomTableViewCell.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 29.11.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var isSeenLabel: UILabel!
    
    public func configure(state: Repository) {
        if state.isSeen == true {
            isSeenLabel.text = "Seen"
        } else {
            isSeenLabel.text = ""
        }
        
    }
    
    static let identifier = "CustomTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
