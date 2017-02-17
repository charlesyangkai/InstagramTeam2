//
//  UserEditeProfileViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 15/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase

class UserEditeProfileViewController: UIViewController {
    
    
    let ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    var displayNameInPost : String?
    
    
    @IBOutlet weak var selectedDisplayImage: UIImageView!{
        didSet {
            selectedDisplayImage.layer.cornerRadius = selectedDisplayImage.frame.size.width / 2
            selectedDisplayImage.clipsToBounds = true
            selectedDisplayImage.backgroundColor = UIColor.green
        }
    }
    @IBOutlet weak var changeProfilePhotoButton: UIButton!{
        didSet {
            changeProfilePhotoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
            changeProfilePhotoButton.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayUserName()
        navigationItem.rightBarButtonItem = userEndEditButton
    }

    
    
/////////////////////////////////////////////////////////////////////////////
    
    
    //create a "done" button programatically 
    
    let userEndEditButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(updateUserInfo))

    func updateUserInfo() {
        guard let name = nameTextField.text,
            let username = usernameTextField.text,
            let website = websiteTextField.text,
            let bioInfo = bioTextField.text else
        { return }
        
        let ref = FIRDatabase.database().reference()
        
        let value = ["name": name, "username": username, "website": website, "bio": bioInfo]
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("username").child(uid!).updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("err")
                return
            }
            print("successfully update user information")
            //self.dismiss(animated: true, completion: nil)
            
        })
    }
    

    
    func displayUserName() {
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("username").child(uid!).observe(.value, with: {
            (snapshot) in
            
            print(snapshot)
            
            let value = snapshot.value as? NSDictionary
            let displayName = value?["name"] as? String ?? ""
            
            self.nameTextField.text = displayName

        })
    }
}


extension UserEditeProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        var selectedImageByUser : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageByUser = editedImage
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageByUser = originalImage
            
        }
        if let selectedImage = selectedImageByUser {
            selectedDisplayImage.image = selectedImageByUser
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //upload image to firebase
    
    func uploadImage(image: UIImage) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        let ref = FIRStorage.storage().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.child("username").child(uid!)
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
}
