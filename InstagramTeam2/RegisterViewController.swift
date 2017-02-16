//
//  RegisterViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 13/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    
    var profilePictureUrl: URL?
    
    @IBOutlet weak var userSelectImage: UIImageView! {
        didSet {
            userSelectImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
            userSelectImage.isUserInteractionEnabled = true
            
            return
        }
    }
    
    @IBOutlet weak var usernameFirstTime: UITextField!
    
    @IBOutlet weak var emailFirstTime: UITextField!
    
    @IBOutlet weak var passwordFirstTime: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet {
            registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
    }
    
    
    func uploadProfilePicture(image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        
        // Giving stored data a type of data
        metadata.contentType = "image/jpeg"
        
        // Giving a name to profilePicture selected
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let profilePictureName = ("image \(convertedTimeStamp).jpeg")
        
        
        // Making sure there is a profilePicture before proceeding, if nil then return
        guard let profilePictureData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        // Uploading image to firebase storage
        storageRef.child(profilePictureName).put(profilePictureData, metadata: metadata) { (meta, error) in
            
            // Returning to chat by dismissing current view controller
            self.dismiss(animated: true, completion: nil)
            
            if error != nil {
                print("No image detected")
                return
            }
            
            if let downloadUrl = meta?.downloadURL(){
                // Step 1 of setting image url string
                self.profilePictureUrl = downloadUrl
            }
        }
    }
    
    
    func handleRegister(){
        
        FIRAuth.auth()?.createUser(withEmail: emailFirstTime.text!, password: passwordFirstTime.text!, completion: { (user,error) in
            if error != nil{
                print(error! as NSError)
                return
            }
            
            
            // Step 1. Defining the value, what kind of child users shoudl have
            var userDictionary : [String: Any] = ["username" : self.usernameFirstTime.text ?? "", "email": self.emailFirstTime.text ?? "", "password": self.passwordFirstTime.text ?? ""]
            
            // Convert profile picture url to string
            if let urlString = self.profilePictureUrl?.absoluteString{
                // Dictionary with key image stores urlString as value
                userDictionary["profilePicture"] = urlString ?? "no URL"
                
            }
            
            // Step 2. Definining the key/id
            guard let validUserID = user?.uid else {return}
            //
            
            // Step 3. Adding the child values [key: value]
            self.dbRef.child("username").updateChildValues([validUserID: userDictionary])
        })
    }
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            userSelectImage.image = selectedImage
        }
        
        uploadProfilePicture(image: selectedImageFromPicker!)
        
        dismiss(animated: true, completion: nil)
    }
}




























