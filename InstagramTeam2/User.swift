//
//  User.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 15/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import Foundation

class User{
    var username: String?
    var profileDescription: String?
    var profilePicture: URL?
    var id: String?
    // liked post = array of post id
    
    
    
    // To send data to firebase database
    init(withDictionary dictionary: [String: Any], index: Int){

        id = String(index)
        username = dictionary["username"] as? String
        profileDescription = dictionary["profileDescription"] as? String
        
        if let profilePictureURL = dictionary["profilePicture"] as? String{
            profilePicture = URL(string: profilePictureURL)
    
        }
    }
}
