//
//  ViewController.swift
//  ImagePicker
//
//  Created by Moritz Gort on 08/09/15.
//  Copyright (c) 2015 Gabriele Gort. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var viewIsMovedUp = false
    
    var tempTopText = ""
    var tempBottomText = ""
    var tempImage = UIImage()
    var editOrNew = "NEW"
    
    var fontIndex = 12
    
    var imageSource: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: UIFont.familyNames()[0], size: 40)!,
        NSStrokeWidthAttributeName: -4.0,
    ]
  
// MARK: 'ViewDid' Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        adjustFont()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters

        shareButton.enabled = false
        if editOrNew == "EDIT" {
            topTextField.text = tempTopText
            bottomTextField.text = tempBottomText
            imageView.image = tempImage
        }
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        for family in UIFont.familyNames() as [String] {
            print("fam: \(family) at index")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Move up view when pressed on keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !textFieldInBoundaries(notification) {
            view.frame.origin.y -= getKeyboardHeight(notification)
            viewIsMovedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if viewIsMovedUp {
            view.frame.origin.y += getKeyboardHeight(notification)
            viewIsMovedUp = false
        }
    }
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldInBoundaries(notification: NSNotification) -> Bool {
        var firstResponder: UITextField
        if topTextField.isFirstResponder() {
            firstResponder = topTextField
        } else {
            firstResponder = bottomTextField
        }
        
        if (view.frame.origin.y + firstResponder.frame.origin.y) > (view.frame.height - getKeyboardHeight(notification)) {
            return false
        } else {
            return true
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
// MARK: Save Finished Image
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memeImage: generateMemedImage())
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if editOrNew == "NEW" {
            appDelegate.memes.append(meme)
        } else {
            appDelegate.memes[appDelegate.memes.count - 1] = meme
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        //TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
        
        return memedImage
    }

// MARK: Picking an Image
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        let alert  = UIAlertController(title: "Source Type", message: "Access Camera or Library?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {UIAlertAction in self.pickCameraImage()})
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) {UIAlertAction in self.pickLibraryImage()})
        self.showDetailViewController(alert, sender: self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK: Sharing the finished image
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        presentViewController(activityVC, animated: true, completion: {
            () -> Void in self.save()
        })
    }
    
//MARK: Keyboard Dismiss
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        shareButton.enabled = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {() -> Void in self.save()})
    }
// MARK: Helper Functions
    
    func pickCameraImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func pickLibraryImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            if (fontIndex < (UIFont.familyNames().count - 1)) {
                self.fontIndex++
            }
        } else if (sender.direction == .Right) {
            if (fontIndex > 0) {
                self.fontIndex--
            }
        }
        adjustFont()
    }
    
    func adjustFont() {
        topTextField.font = UIFont(name: UIFont.familyNames()[fontIndex], size: 40)!
        bottomTextField.font = UIFont(name: UIFont.familyNames()[fontIndex], size: 40)!
    }
    
    
    
}

