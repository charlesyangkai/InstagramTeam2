//
//  CameraViewController.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 13/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit

class CameraGalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //let picker = UIImagePickerController()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateView()
    }


    func setupView(){
        setupSegmentedControl()
    }
    
    
    func setupSegmentedControl(){
        
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Camera", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Gallery", at: 1, animated: false)
        // The function selectionDidChange with sender uisegmentedcontrol is linked with .valueChanged
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    
        // Select first segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    
    func selectionDidChange(_ sender: UISegmentedControl){
        updateView()
    }
    
    
//    private lazy var cameraViewController: CameraViewController = {
//        
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "TimelineStoryboard", bundle: Bundle.main)
//        // Instantiate View Controller
//        var viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
//        // Add View Controller as Child Controller
//        return viewController
//    }()
//    private lazy var galleryViewController: GalleryViewController = {
//        
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "TimelineStoryboard", bundle: Bundle.main)
//        // Instantiate View Controller
//        var viewController = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
//        // Add View Controller as Child Controller
//        return viewController
//    }()
    
    
    private lazy var cameraImagePickerController: UIImagePickerController? = {
        
        
        let picker = UIImagePickerController()

        print("Camera View Controller Will Appear")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .overFullScreen
            //present(picker,animated: true,completion: nil)
            return picker
        }else{
            self.noCamera()
            return nil
        }
        
        // Add View Controller as Child Controller
        // return picker
    }()
    
    
    private lazy var galleryImagePickerController : UIImagePickerController = {

        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        print("Gallery View Controller Will Appear")
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        // Add View Controller as Child Controller
        return picker
    }()
    
    
    private func add(asChildViewController viewController: UIImagePickerController){
        
        // Add Child View Controller
        addChildViewController(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    
    private func remove(asChildViewController viewController: UIImagePickerController){
        
        // Notify Child View Controller (nil indicates that the child view controller is about to be removed from the container view controller)
        viewController.willMove(toParentViewController: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    
    private func updateView(){
        if segmentedControl.selectedSegmentIndex == 0{
            remove(asChildViewController: galleryImagePickerController)
            if cameraImagePickerController == nil {
                noCamera()
                return
            }
            add(asChildViewController: cameraImagePickerController!)
        } else{
            if cameraImagePickerController != nil {
                remove(asChildViewController: cameraImagePickerController!)
            }
            add(asChildViewController: galleryImagePickerController)
        }
    }
    
    
    func noCamera(){
        let alert = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    

    
    
    
    //MARK: Delegates for Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
            remove(asChildViewController: galleryImagePickerController)
            if cameraImagePickerController != nil {
                remove(asChildViewController: cameraImagePickerController!)
            }
        }else{
            print("somethign is wrong")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
