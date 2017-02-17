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
    var image: URL?
    var caption: String?
    var timeStamp: TimeInterval?
    //var comments: [Comment] = []
    
    
    
    // So it can be declared in other classes
    init(withDictionary dictionary: [String: Any]){
        
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
        
        // timeStamp = dictionary["timeStamp"] as? TimeInterval
        
        
        if let timeStampTI = dictionary["timeStamp"] as? String {
            timeStamp = TimeInterval(timeStampTI)
        }
    }
    
    

}
