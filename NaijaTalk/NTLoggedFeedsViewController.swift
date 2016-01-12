//
//  NTLoggedFeedsViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTLoggedFeedsViewController: UIViewController,MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var logger:NTUser?
    @IBOutlet var tableView: UITableView!
    var feeds = [NTlogs]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 300
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
            self.getFeeds()
            }) { () -> Void in
//                spinner.hide(true)
        }

    }
    
    func getFeeds(){
        NTFirebaseHelper.shared.logsRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            var logFeeds = [NTlogs]()
            for item in snapshot.children {
                if let childSnap:FDataSnapshot = item as? FDataSnapshot {
                    for snap in childSnap.children {
                        let logFeed = NTlogs(snapshot: snap as! FDataSnapshot)
                        logFeeds.append(logFeed)
                    }
                }
            }
            self.feeds = logFeeds
            self.tableView.reloadData()
            
            
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        NTFirebaseHelper.shared.logsRef?.removeAllObservers()
    }
    
    func addComment(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NTAddCommentViewController") as! NTAddCommentViewController
        controller.feed = feeds[sender.tag]
        let navController = UINavigationController(rootViewController: controller)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func like(sender:UIButton) {
        let feed:NTlogs = feeds[sender.tag]
        NTFirebaseHelper.shared.updateFeedLike(feed)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FeedDetails" {
            let controller = segue.destinationViewController as! NTFeedDetailsTableViewController
            controller.feed = sender as! NTlogs
            controller.feedlogger = NTFirebaseHelper.shared.sharedUser
        }
    }
}

extension NTLoggedFeedsViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTLogFeedCell") as! NTFeedsTableViewCell
        let feed = feeds[indexPath.row]
        
        let postLoggerRef = NTFirebaseHelper.shared.usersRef?.childByAppendingPath(feed.postLogger)
        postLoggerRef?.observeEventType(.Value, withBlock: { (loggerSnap:FDataSnapshot!) -> Void in
            if loggerSnap.exists() {
                 self.logger = NTUser(snapshot: loggerSnap)
                cell.nameLabel.text = self.logger!.name
                cell.profileImageView.sd_setImageWithURL(NSURL(string: self.logger!.picture!), placeholderImage: UIImage(named: "defaultImage"))
            }
        })
        cell.likeBtn.tag = indexPath.row
        cell.commentBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        cell.commentBtn.addTarget(self, action: "addComment:", forControlEvents: .TouchUpInside)
        
        cell.feedTopicLabel.text = feed.headline
        cell.detailLabel.text = feed.logDetail
        cell.timeLabel.text = feed.createdDate
        
        if feed.logImage.isEmpty {
            cell.feedImageView?.image = UIImage(named: "flag")
        }else {
            let decodedImageData = NSData(base64EncodedString: feed.logImage, options: NSDataBase64DecodingOptions(rawValue: 0))
            cell.feedImageView?.image = UIImage(data: decodedImageData!)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let feed = feeds[indexPath.row]
        performSegueWithIdentifier("FeedDetails", sender: feed)
    }
}


