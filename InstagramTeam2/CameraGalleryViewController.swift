//
//  CameraViewController.swift
//  InstagramTeam2
//
//  Created by Charles Lee on 13/2/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CameraGalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //static var image: UIImage?
    //static var timestamp: TimeInterval?
    
    //let picker = UIImagePickerController()
    
    var dbRef: FIRDatabaseReference!
    
    var imageUrl: URL?
    var userID: String?
    var displayThisName: String?
    var displayThisProfilePicture: String?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!{
        didSet{
            postButton.addTarget(self, action: #selector(postImage), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        userID = FIRAuth.auth()?.currentUser?.uid
        dbRef.child("username").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["username"] as? String ?? ""
            let displayProfilePicture = value?["profilePicture"] as? String ?? ""
            self.displayThisName = displayName
            self.displayThisProfilePicture = displayProfilePicture
        })
        setupView()
        updateView()
    }
    
    
    func uploadImage(image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        
        // Giving stored data a type of data
        metadata.contentType = "image/jpeg"
        
        // Giving a name to image selected
        let timestampImage = String(Date.timeIntervalSinceReferenceDate)
        //print(timestamp)
        let convertedTimeStampImage = timestampImage.replacingOccurrences(of: ".", with: "")
        //print(convertedTimeStamp)
        let imageName = ("image \(convertedTimeStampImage).jpeg")
        
        
        // Making sure there is an image before proceeding, if nil then return
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        // Uploading image to firebase
        storageRef.child(imageName).put(imageData, metadata: metadata) { (meta, error) in

            
            if error != nil {
                return
            }
            
            if let downloadUrl = meta?.downloadURL(){
                // Step 1 of setting image url string
                self.imageUrl = downloadUrl
                self.postImage()
            }
        }
    }
    
    
    func postImage(){
        
        guard let image = imageView.image else {return}
        
        let caption = textView.text
        
        // Getting the current time
        let timestamp = Date.timeIntervalSinceReferenceDate
        
        // Creating a dictionary that stores the value for current post
        var postDictionary : [String: Any] = ["username" : displayThisName, "caption" : caption, "profilePicture": displayThisProfilePicture, "timeStamp" : timestamp]
        
        // Step 2 of setting image url string
        // Converting url to string
        if let urlString = imageUrl?.absoluteString{
            // Dictionary with key image stores urlString as value
            postDictionary["image"] = urlString
        }
        
        // Uploading current post class as dictionary to firebase
        dbRef.child("posts").childByAutoId().setValue(postDictionary)
        // dbRef.child("posts").child(String(chatIndex)).setValue(postDictionary)
        
        self.loadHomePage()
        
    }

    
    func loadHomePage(){
        let instaPage = HomeViewController()
        present(instaPage, animated: true, completion: nil)
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
            picker.modalPresentationStyle = .none
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
            uploadImage(image: chosenImage)
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
