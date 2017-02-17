//
//  Post.swift
//  
//
//  Created by Charles Lee on 15/2/17.
//
//

import Foundation


class Post {
    
    var username: String?
    var userID: String?
    var profilePicture: URL?
    var noOfLikes: Int?
    //var userLikes = array of user id 
    //var comment = array of comment id
    var image: URL?
    var caption: String?
    var timeStamp: TimeInterval?
    var postID: String?
    var comments: [String] = []
    
    
    
    
    // So it can be declared in other classes
    init(withDictionary dictionary: [String: Any]){
        
        comments = (dictionary["comments"] as? [String])!
        
        postID = dictionary["postID"] as? String
        
        username = dictionary["username"] as? String
        userID = dictionary["userID"] as? String
        
        
        if let profilePictureURL = dictionary["profilePicture"] as? String{
            profilePicture = URL(string: profilePictureURL)
        }
        
        noOfLikes = dictionary["noOfLikes"] as? Int
        
        if let imageURL = dictionary["image"] as? String{
            image = URL(string: imageURL)
        }
        
        caption = dictionary["caption"] as? String
        
        timeStamp = dictionary["timeStamp"] as? TimeInterval
        // firebase has timestamp as String, so when u retrieve you need to retrieve a string, then only convert it to time interval in the end
        //if let timeStampTI = dictionary["timeStamp"] as? String {
          //  timeStamp = TimeInterval(timeStampTI)
        //}
    }
}
