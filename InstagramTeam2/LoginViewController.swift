//
//  LoginViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 13/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UINavigationItem!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        guard let controllerDirection = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
        
        navigationController?.pushViewController(controllerDirection, animated: true)
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
            loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!, completion: { (user,error) in
            
            //check if error
            if error != nil {
                print(error! as NSError)
                return
            }
            
            self.loadChannelPage()
        })
    }
    
    
    
    func loadChannelPage(){
        let instaPage = CustomTabBarController()
        present(instaPage, animated: true, completion: nil)
    }
    
    
    
    //            //get the user
    //            self.handleUser(user: user!)
    //
    //            })
    //    }
    
    //    func handleUser(user: FIRUser) {
    //
    //        guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController else {return}
    //
    //        navigationController?.pushViewController(controller, animated: true)
    //
    //
    //        print("User found :\(user.uid)")
    //    }
    //
    //    func checkUserUID() -> String {
    //        guard let uid = FIRAuth.auth()?.currentUser?.uid
    //            else{
    //                return ""
    //
    //        }
    //        return uid
    //
    //
    //
    //    }
    
    
    
    
}
