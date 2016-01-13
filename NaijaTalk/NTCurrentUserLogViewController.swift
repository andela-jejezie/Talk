//
//  NTCurrentUserLogViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTCurrentUserLogViewController: UIViewController, MBProgressHUDDelegate {

    @IBOutlet var tableView: UITableView!
    private var feeds = [NTlogs]()
    private let currentUserLogRef = NTFirebaseHelper.shared.logsRef?.childByAppendingPath(NTFirebaseHelper.shared.sharedUser.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 250
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let spinner = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.view.addSubview(spinner)
        spinner.mode = MBProgressHUDMode.Indeterminate
        spinner.delegate = self
        spinner.labelText = "Loading..."
        spinner.detailsLabelText = "Just a second :)"
        spinner.square = true
        spinner.showAnimated(true, whileExecutingBlock: { () -> Void in
            self.getMyFedds()
            }) { () -> Void in
//                spinner.hide(true)
        }
        


    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        currentUserLogRef?.removeAllObservers()
    }
    
    func getMyFedds(){
        var logFeds = [NTlogs]()
        currentUserLogRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            for item in snapshot.children {
                let feed = NTlogs(snapshot: item as! FDataSnapshot)
                logFeds.append(feed)
                print(feed)
            }
            self.feeds = logFeds
            self.tableView.reloadData()
        })
    }
    
    func addComment(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NTAddCommentViewController") as! NTAddCommentViewController
        controller.feed = feeds[sender.tag]
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func like(sender:UIButton) {
        let feed:NTlogs = feeds[sender.tag]
        NTFirebaseHelper.shared.updateFeedLike(feed)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MyFeedDetails" {
            let controller = segue.destinationViewController as! NTFeedDetailsTableViewController
            controller.feed = sender as! NTlogs
            controller.feedlogger = NTFirebaseHelper.shared.sharedUser
      
        }
    }

}


extension NTCurrentUserLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFeedCell") as! MyFeedTableViewCell
        let feed = feeds[indexPath.row]

        cell.nameLabel.text = NTFirebaseHelper.shared.sharedUser.name
        cell.profileImageView.sd_setImageWithURL(NSURL(string: NTFirebaseHelper.shared.sharedUser.picture!), placeholderImage: UIImage(named: "defaultImage"))

        cell.likeBtn.tag = indexPath.row
        cell.commentBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        cell.commentBtn.addTarget(self, action: "addcomment", forControlEvents: .TouchUpInside)
        
        cell.feedTopicLabel.text = feed.headline
        cell.detailLabel.text = feed.logDetail
        cell.timeLabel.text = feed.createdDate
        
        if feed.logImage.isEmpty {
            cell.feedImageView?.image = UIImage(named: "flag")
        }else {
            let decodedImageData = NSData(base64EncodedString: feed.logImage, options: NSDataBase64DecodingOptions(rawValue: 0))
            cell.feedImageView?.image = UIImage(data: decodedImageData!)
        }
        
        if feed.likes > 0 {
            cell.numOfLikeLabel.text = String(feed.likes) + " Like"
            cell.numOfLikeLabel.hidden = false
        }
        if feed.numberOfComment > 0 {
            cell.numOfCommentLabel.text = String(feed.numberOfComment) + " Comment"
            cell.numOfCommentLabel.hidden = false
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let feed = feeds[indexPath.row]
        performSegueWithIdentifier("MyFeedDetails", sender: feed)
    }
}