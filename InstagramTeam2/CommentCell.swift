//
//  CommentViewCell.swift
//  
//
//  Created by Charles Lee on 16/2/17.
//
//

import UIKit

class CommentCell: UITableViewCell {
    
    
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var commentUsername: UILabel!
    
    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var commentTimestamp: UILabel!

    
    
    // Ultimate purpose to do this is to allow Post View Controller to use this custom cell programatically
    static let cellIdentifier = "CommentCell"
    static let cellNib = UINib(nibName: "CommentCell", bundle: Bundle.main)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
