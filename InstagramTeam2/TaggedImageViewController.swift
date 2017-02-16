//
//  TaggedImageViewController.swift
//  InstagramTeam2
//
//  Created by Rock on 15/02/2017.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit
import Photos

class TaggedImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var taggedImagesArray = [UIImage]()
    
    @IBOutlet weak var taggedImageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taggedImageCollectionView.delegate = self
        taggedImageCollectionView.dataSource = self
        
        grabPhotos()
        
        navigationItem.title = "Photo of you"
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
                        
                        self.taggedImagesArray.append(image!)
                    })
                    
                }
                
            }
            else{
                print ("No Photo Detected")
                self.taggedImageCollectionView.reloadData()
            }
            
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taggedImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Two", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = taggedImagesArray[indexPath.row]
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3
        
        
        return CGSize(width: width, height: width)
    }


}
