//
//  DisplayMemeViewController.swift
//  ImagePicker
//
//  Created by Moritz Gort on 04/10/15.
//  Copyright © 2015 Gabriele Gort. All rights reserved.
//

import UIKit

class DisplayMemeViewController: UIViewController {

    @IBOutlet weak var finishedMemeImageView: UIImageView!
    
    var finishedImage: UIImage!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishedMemeImageView.image = finishedImage
        tabBarController?.hidesBottomBarWhenPushed = true
    }
    @IBAction func deleteButtonPressed(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete this image?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) {UIAlertAction in self.deleteImage()})
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {UIAlertAction in Void})
        
        showDetailViewController(alert, sender: self)
        
    }
    
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        presentEditView(index)
    }
    
    func deleteImage() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index)
        //TODO: dismiss not working
        navigationController?.popViewControllerAnimated(true)
    }
    
    func presentEditView(imageIndex: Int) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("CreateMemeVC") as! MemeEditorViewController
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[index]
        
        controller.imageIndex = index
        controller.editOrNew = "EDIT"
        controller.tempTopText = meme.topText
        controller.tempBottomText = meme.bottomText
        controller.tempImage = meme.image
        
        presentViewController(controller, animated: true, completion: nil)
    }
}
