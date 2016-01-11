//
//  NTLoggedFeedsViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTLoggedFeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var logger:NTUser?
    @IBAction func comment(sender: UIButton) {
    }
    @IBAction func like(sender: UIButton) {
        
        let feed = feeds[sender.tag]
        var numLike = feed.likes
        numLike++
        let feedRef = NTFirebaseHelper.shared.logsRef?.childByAppendingPath(feed.postLogger).childByAppendingPath(feed.uid)
        let update = [
            "likes":numLike
        ]
        feedRef?.updateChildValues(update)
    }
    @IBOutlet var tableView: UITableView!
    var feeds = [NTlogs]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 300
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FeedDetails" {
            let destinationViewController = segue.destinationViewController as! NTFeedDetailViewController
            destinationViewController.feed = sender as! NTlogs
            destinationViewController.logger = self.logger!
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
        
        cell.feedTopicLabel.text = feed.headline
        cell.feedDescriptionTextView.text = feed.logDetail
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


