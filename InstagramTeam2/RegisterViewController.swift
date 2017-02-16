//
//  RegisterViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 13/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    var databaseRef : FIRDatabaseReference!

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

        
    }
    
    func handleRegister () {
        
        let username = usernameFirstTime.text
        let email = emailFirstTime.text
        let password = passwordFirstTime.text
        let image = userSelectImage.image
        
        FIRAuth.auth()?.createUser(withEmail: emailFirstTime.text!, password: passwordFirstTime.text!, completion: { (user,error) in
            if error != nil{
                print(error! as NSError)
                return
            }
            
            self.handleUser(user: user!)
            
        
            })
        
    }
    
    func handleUser(user: FIRUser) {
        print("User found :\(user.uid)")
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
        
        dismiss(animated: true, completion: nil)
    }
}




























