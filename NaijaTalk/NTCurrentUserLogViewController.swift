//
//  NTCurrentUserLogViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTCurrentUserLogViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var feeds = [NTlogs]()
    private let currentUserLogRef = NTFirebaseHelper.shared.logsRef?.childByAppendingPath(NTFirebaseHelper.shared.sharedUser.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        currentUserLogRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            for item in snapshot.children {
                let feed = NTlogs(snapshot: item as! FDataSnapshot)
                self.feeds.append(feed)
                print(feed)
            }
        })
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        currentUserLogRef?.removeAllObservers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MyFeedDetails" {
            let destinationViewController = segue.destinationViewController as! NTFeedDetailViewController
            destinationViewController.feed = sender as! NTlogs
            destinationViewController.logger = NTFirebaseHelper.shared.sharedUser
        }
    }

}


extension NTCurrentUserLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTMyFeedCell") as! NTFeedsTableViewCell
        let feed = feeds[indexPath.row]

        cell.nameLabel.text = NTFirebaseHelper.shared.sharedUser.name
        cell.profileImageView.sd_setImageWithURL(NSURL(string: NTFirebaseHelper.shared.sharedUser.picture!), placeholderImage: UIImage(named: "defaultImage"))

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
        performSegueWithIdentifier("MyFeedDetails", sender: feed)
    }
}