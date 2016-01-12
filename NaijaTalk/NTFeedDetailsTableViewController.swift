//
//  NTFeedDetailsTableViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 12/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTFeedDetailsTableViewController: UITableViewController {
    var arr:[AnyObject] = [
        
         [
            "profileImageView": "defaultImage",
            "nameLabel": "Johnson Chidi",
            "titleLabel" : "Testing VFL",
            "bodyLabel" : "Been thinking of an app that would contribute to national development. Improving communication between the people and the government seem to be interesting to me. Plus having a way of helping people hold the government accountable. So I’m thinking of a mobile app where people can log issues. Imagine a village with a no good drinking water and someone goes into the app and open an issue on this. With the location of the village, the app will display the state representative of the constituency of the village, the federal representative of the constituency of the village, the senatorial district and the senator, the local government chairman etc. Now other users can comment and also like the issue. Issues with more likes are considered highly important."
        ]
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let arrdict = arr[indexPath.row]
        let cell:NTCommentTableViewCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! NTCommentTableViewCell
        cell.profileImageView.image = UIImage(named: arrdict["profileImageView"] as! String)
        cell.nameLabel.text = arrdict["nameLabel"] as? String
        cell.bodyLabel.text = arrdict["bodyLabel"] as? String

        return cell
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
