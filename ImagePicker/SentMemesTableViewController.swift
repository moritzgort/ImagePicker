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
    
    var valueToPass: UIImage!
    var detailIndex: Int!
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        valueToPass = memes[indexPath.row].image
        detailIndex = indexPath.row
        performSegueWithIdentifier("tableToDisplay", sender: self)
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! MemeEditorViewController
        controller.editOrNew = "NEW"
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableToDisplay" {
            let controller = segue.destinationViewController as! DisplayMemeViewController
            controller.finishedImage = valueToPass
            controller.index = detailIndex
        }
    }
}
