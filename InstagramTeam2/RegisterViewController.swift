//
//  RegisterViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 13/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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
    
    @IBOutlet weak var proceedButtonInReg: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        var selectedImage: UIImage?
    
     
    
    
    
    
    
    
    
    
}




























