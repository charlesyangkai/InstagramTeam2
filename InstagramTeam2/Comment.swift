//
//  Comment.swift
//  
//
//  Created by Charles Lee on 15/2/17.
//
//

import Foundation

class Comment {
    
    var username: String?
    var text: String?
    var timeStamp: TimeInterval?
    var profilePicture: URL?
    var postID: String?
    var commentID: String?
    
    init(withDictionary dictionary: [String: Any]){
        
        commentID = dictionary["commentID"] as? String
        
        postID = dictionary["postID"] as? String
        
        username = dictionary["username"] as? String
        text = dictionary["text"] as? String
        
        if let profilePictureURL = dictionary["profilePicture"] as? String{
            profilePicture = URL(string: profilePictureURL)
        }
        
        timeStamp = dictionary["timeStamp"] as? TimeInterval
    }
}
