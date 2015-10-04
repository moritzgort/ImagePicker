//
//  SentMemesTableViewController.swift
//  ImagePicker
//
//  Created by Moritz Gort on 03/10/15.
//  Copyright © 2015 Gabriele Gort. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.imageView?.image = memes[indexPath.row].image
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateMemeVC") as! ViewController
        controller.tempTopText = memes[indexPath.item].topText
        controller.tempBottomText = memes[indexPath.item].bottomText
        controller.tempImage = memes[indexPath.item].image
        controller.editOrNew = "EDIT"
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! ViewController
        controller.editOrNew = "NEW"
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
