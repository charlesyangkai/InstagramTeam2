//
//  CommentViewController.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 16/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CommentViewController: UIViewController {
    
    var userID: String?
    var displayThisName: String?
    var displayThisProfilePicture: String?
    var currentComments: [Comment] = []
    var currentPostID: String?
    var commentID: [String] = []
    
    // Step 1 of timestamp
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        return _dateFormatter
    }()
    
    
     var dbRef: FIRDatabaseReference!

    @IBOutlet weak var commentTableView: UITableView!{
        didSet{
            
            // The usual delegate and data source for table view
            commentTableView.dataSource = self
            commentTableView.delegate = self
            
            // Register custom chat cell to chat view controller
            commentTableView.register(CommentCell.cellNib, forCellReuseIdentifier: CommentCell.cellIdentifier)
            
            // Configure autolayout for row height
            commentTableView.estimatedRowHeight = 80
            commentTableView.rowHeight = UITableViewAutomaticDimension
        }
    }


    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var commentSendButton: UIButton!{
        didSet{
            commentSendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
        
        // Getting the display name for current user
        userID = FIRAuth.auth()?.currentUser?.uid
        dbRef.child("username").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["displayName"] as? String ?? ""
            self.displayThisName = displayName
            let displayProfilePicture = value?["profilePicture"] as? String ?? ""
            self.displayThisProfilePicture = displayProfilePicture
        })
        
        
        observeComment()
    }

    
    
    // Sending All Comments To The Same Place
    func sendComment(){
        guard let text = commentTextField.text else {return}
        
        // Getting the current time
        let timestamp = Date.timeIntervalSinceReferenceDate
        
        // Creating a dictionary that stores the value for current post
        var commentDictionary : [String: Any] = ["username" : displayThisName, "text" : text, "profilePicture": displayThisProfilePicture, "timeStamp" : timestamp, "postID": currentPostID]
        
        // Uploading current comment as dictionary to firebase
        dbRef.child("comments").childByAutoId().setValue(commentDictionary) { (error, newReference) in
            
            let referenceKey = newReference.key
            self.dbRef.child("posts").child(self.currentPostID!).child("comments").setValue([referenceKey:true])

            self.commentID.append(referenceKey)
        }
        
        // Clearing message text field when send button is hit
        commentTextField.text = ""
    }
    
    
    
    
    func observeComment(){
        
        // Fetching All Comments for the particular post From Firebase Database
        // Looping happens here
        dbRef.child("comments").observe(.childAdded, with: { (snapshot) in
            
            // Making sure all chats are of type class dictionary before proceeding
            guard let value = snapshot.value as? [String: Any] else {return}
            
            // Init of Post
            // Making each post of class post
            let newComment = Comment(withDictionary: value)
    
            // Appending each chat
            self.appendComment(newComment)
        })
    }
    
    
    
    func appendComment(_ comment: Comment){
        
        // Append post to currentPosts
        currentComments.append(comment)
        commentTableView.reloadData()
    }
}

    








extension CommentViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellIdentifier, for: indexPath) as? CommentCell
            else {
                return UITableViewCell()
        }
        
        let comment = currentComments[indexPath.row]
        
        if let url = comment.profilePicture{
            
            if let data = try? Data(contentsOf: url) {
                cell.commentImageView.image = UIImage(data: data)
            }
        }
        
        
        cell.commentUsername.text = comment.username
        cell.commentText.text = comment.text
        
        
        // Step 2 of timestamp
        //if let timeStamp = comment.timeStamp {
            cell.commentTimestamp.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: comment.timeStamp!))
        //} else {
        //    cell.commentTimestamp.text = ""
        //}
        return cell
    }
    
}

