//
//  PostViewController.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 15/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {
    
    var dbRef: FIRDatabaseReference!
    var userID: String?
    var displayThisName: String?
    var displayThisProfilePicture: String?
    
    // Step 1 of timestamp
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        return _dateFormatter
    }()
    
    
    // For image to be posted
    var imageUrl: URL?
    
    static var currentPosts: [Post] = []
    
    
    @IBOutlet weak var postTableView: UITableView!{
        didSet{
            // The usual delegate and data source for table view
            postTableView.dataSource = self
            
            // Register custom post cell to home view controller
            postTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
            
            // Configure autolayout for row height
            postTableView.estimatedRowHeight = 80
            postTableView.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "I n s t a g r a m"
        dbRef = FIRDatabase.database().reference()
        
        // Getting the username and profilePicture for current user
        userID = FIRAuth.auth()?.currentUser?.uid
        dbRef.child("username").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["username"] as? String ?? ""
            let displayProfilePicture = value?["profilePicture"] as? String ?? ""
            self.displayThisName = displayName
            self.displayThisProfilePicture = displayProfilePicture
        })
        
        
        observePosts()
        
        //child("users").updateChildValues([validUserID: userDictionary])
        //VS
        //dbRef.child("posts").childByAutoId().setValue(postDictionary)
        //BOTH GIVES ID, update adds key value, set value just adds key
        //More about update child values?????
    }
    
    
    func observePosts(){
        
        
        // Fetching All Posts From Firebase Database
        // Looping happens here
        dbRef.child("posts").observe(.childAdded, with: { (snapshot) in
            
            // Making sure all chats are of type class dictionary before proceeding
            guard let value = snapshot.value as? [String: Any] else {return}

            // Init of Post
            // Making each post of class post
            let newPost = Post(withDictionary: value)
            
            // Getting post ID
            newPost.postID = snapshot.key
            
            // Appending each chat
            self.appendPost(newPost)
        })
    }
    

    
    func appendPost(_ post: Post){
        
        // Append post to currentPosts
        HomeViewController.currentPosts.append(post)
        postTableView.reloadData()
    }
}

extension HomeViewController: CommentDelegate, UITableViewDataSource {
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewController.currentPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell
            else {
                return UITableViewCell()
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let post = HomeViewController.currentPosts[indexPath.row]
        
        
        // UIImage
        if let imageUrl = post.image{
            if let data = try? Data(contentsOf: imageUrl) {
                cell.postImage.image = UIImage(data: data)
            }
        }
        if let profilePictureUrl = post.profilePicture{
            if let data = try? Data(contentsOf: profilePictureUrl) {
                cell.postProfilePicture.image = UIImage(data: data)
            }else{
                print("stupid nigga")
            }
        } else{
            print("nigga nigga")
        }
        
        
        // UIButton
        cell.postLikeButton.setImage(UIImage(named: "notification"), for: .normal)
        cell.postCommentButton.setImage(UIImage(named: "profile"), for: .normal)
        cell.postViewCommentButton.setTitle("View all \(post.comments.count) comments", for: .normal)
        
        
        // UILabel
        cell.postUsername.text = post.username
        
        cell.postCaption.text = post.caption ?? ""
      
        cell.postNoOfLikes.text = "0 no of likes"
        
        // Step 2 of timestamp
        //if let timeStamp = post.timeStamp {
            cell.postTimestamp.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: post.timeStamp!))
//        } else {
//            cell.postTimestamp.text = "blabla"
//        }
        return cell
        
    }
    
    
    
    
    func didPressButton(button: UIButton, indexPath: IndexPath?) {
        
        guard let validIndexPath = indexPath else { return }
        let post = HomeViewController.currentPosts[validIndexPath.row]
        
        let storyboard = UIStoryboard(name: "TimelineStoryboard", bundle: Bundle.main)
        let commentViewController = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
        navigationController?.pushViewController(commentViewController!, animated: true)
        
        commentViewController?.currentPostID = post.postID
    }
    
}
