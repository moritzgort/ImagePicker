//
//  SentMemesCollectionViewController.swift
//  ImagePicker
//
//  Created by Moritz Gort on 23/09/15.
//  Copyright © 2015 Gabriele Gort. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var numberOfItemsInRow: CGFloat!
    var ownWidth: CGFloat!
    var portrait: Bool = true
    var dimension: CGFloat!
    let space: CGFloat = 3.0
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orientationChanged()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func orientationChanged() {
        portrait = UIApplication.sharedApplication().statusBarOrientation.isPortrait ? true : false
        ownWidth = self.view.frame.width
        numberOfItemsInRow = portrait ? 3.0 : 5.0
        dimension = (ownWidth - ((numberOfItemsInRow - 1) * space)) / numberOfItemsInRow
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSizeMake(dimension, dimension)
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
        cell.imageView.image = memes[indexPath.item].image
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! ViewController
        controller.tempTopText = memes[indexPath.item].topText
        controller.tempBottomText = memes[indexPath.item].bottomText
        controller.tempImage = memes[indexPath.item].image
        controller.editOrNew = "EDIT"
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addMemeButtonPressed(sender: UIBarButtonItem) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! ViewController
        controller.editOrNew = "NEW"
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
