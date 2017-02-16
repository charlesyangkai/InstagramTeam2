//
//  ViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 14/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageArray = [UIImage]()
    
    
    @IBOutlet weak var profileStackButtons: UIStackView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var collectionViewImageButton: UIButton! {
        didSet {
            aspectToFit(button: collectionViewImageButton)
        }
    }
    
    @IBOutlet weak var tableViewImageButton: UIButton!{
        didSet {
            aspectToFit(button: tableViewImageButton)
        }
    }
    
    @IBOutlet weak var taggedImageButton: UIButton!{
        didSet {
            aspectToFit(button: taggedImageButton)
            
            taggedImageButton.addTarget(self, action: #selector(toTaggedPage), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var savedImageButton: UIButton! {
        didSet{
            aspectToFit(button: savedImageButton)
        }
    }
    
    
    @IBOutlet weak var editProfileButton: UIButton! {
        didSet {
            editButtonCornerRadius()
            
            editProfileButton.addTarget(self, action: #selector(toEditProfilePage), for: .touchUpInside)
        }
    }
    
    
//////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    func toTaggedPage(){
        guard let controllerDirection = storyboard?.instantiateViewController(withIdentifier: "TaggedImageViewController") as? TaggedImageViewController else {return}
        
        navigationController?.pushViewController(controllerDirection, animated: true)
    }
    
    func toEditProfilePage() {
        guard let controllerDirection = storyboard?.instantiateViewController(withIdentifier: "UserEditeProfileViewController") as? UserEditeProfileViewController else {return}
        
        navigationController?.pushViewController(controllerDirection, animated: true)
        
    }
    func aspectToFit(button : UIButton) {
        button.imageView?.contentMode = .scaleAspectFit
    }

    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var imageCollectiongView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectiongView.delegate =  self
        imageCollectiongView.dataSource = self
        
        grabPhotos()
        
        displayImageView.backgroundColor = UIColor.green
        displayImageView.layer.cornerRadius = displayImageView.frame.size.width / 2
        displayImageView.clipsToBounds = true
        
    }
    
    func editButtonCornerRadius() {
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.gray.cgColor
        editProfileButton.layer.cornerRadius = 5
        editProfileButton.layer.masksToBounds = true
    }
    
    
    func grabPhotos() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption) {
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    
                    imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset , targetSize: .init(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                        image, eror in
                        
                        self.imageArray.append(image!)
                    })
                    
                }
                
            }
            else{
                print ("No Photo Detected")
                self.imageCollectiongView.reloadData()
            }
            
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3
    
        
        return CGSize(width: width, height: width)
    }



}


 
