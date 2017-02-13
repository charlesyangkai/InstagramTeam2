//
//  CustomTabBarController.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 13/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        
        viewControllers = [createHomeViewController(imageName: "home"), createSearchViewController(imageName: "search"), createCameraViewController(imageName: "camera"), createNotificationViewController(imageName: "notification"), createProfileViewController(imageName: "profile")]
    }
    
    
    func createHomeViewController(imageName: String) -> UINavigationController{
        let homeViewController = UIViewController()
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createSearchViewController(imageName: String) -> UINavigationController{
        let searchViewController = UIViewController()
        let navController = UINavigationController(rootViewController: searchViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createCameraViewController(imageName: String) -> UINavigationController{
        let cameraViewController = UIViewController()
        let navController = UINavigationController(rootViewController: cameraViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createNotificationViewController(imageName: String) -> UINavigationController{
        let notificationViewController = UIViewController()
        let navController = UINavigationController(rootViewController: notificationViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createProfileViewController(imageName: String) -> UINavigationController{
        let profileViewController = UIViewController()
        let navController = UINavigationController(rootViewController: profileViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
