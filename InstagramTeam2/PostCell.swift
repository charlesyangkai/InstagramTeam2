//
//  PostCell.swift
//  
//
//  Created by Charles Lee on 15/2/17.
//
//

import UIKit

protocol CommentDelegate {
    func didPressButton(button: UIButton, indexPath: IndexPath?)
}

class PostCell: UITableViewCell {
    
    var delegate: CommentDelegate!
    var indexPath: IndexPath?
    
    @IBOutlet weak var postProfilePicture: UIImageView!

    @IBOutlet weak var postUsername: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var postLikeButton: UIButton!
    
    @IBOutlet weak var postCommentButton: UIButton!
    
    @IBOutlet weak var postNoOfLikes: UILabel!

    @IBOutlet weak var postCaption: UILabel!
    
    @IBOutlet weak var postViewCommentButton: UIButton!{
        didSet{
            delegate.didPressButton(button: postViewCommentButton, indexPath: indexPath)
        }
    }

    @IBOutlet weak var postTimestamp: UILabel!
    
    
    // Ultimate purpose to do this is to allow Post View Controller to use this custom cell programatically
    static let cellIdentifier = "PostCell"
    static let cellNib = UINib(nibName: "PostCell", bundle: Bundle.main)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
