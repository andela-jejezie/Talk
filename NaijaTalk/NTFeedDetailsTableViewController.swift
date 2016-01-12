//
//  NTFeedDetailsTableViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 12/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTFeedDetailsTableViewController: UITableViewController, MBProgressHUDDelegate {
    
    var feed:NTlogs!
    var feedlogger:NTUser!
    var combinedArray:[AnyObject] = []
    var commentRef:Firebase!

    override func viewDidLoad() {
        super.viewDidLoad()
        commentRef = NTFirebaseHelper.shared.commentsRef?.childByAppendingPath(feed.uid)
        self.combinedArray.append(self.feed)
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
            self.getComment()
            }) { () -> Void in
//                spinner.hide(true)
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        commentRef.removeAllObservers()
    }
    
    func getComment() {
        commentRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
            var comments = [Comment]()
            for item in snapshot.children {
                if let childSnap:FDataSnapshot = item as? FDataSnapshot {
                    print(childSnap)
                        let comment = Comment(snapshot: childSnap)
                        comments.append(comment)
                }
            }
            
            if comments.count > 0 {
                self.combinedArray = self.combinedArray + comments
                comments = []
            }
            self.tableView.reloadData()
        })
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return combinedArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:NTFeedDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("DetailFeedCell", forIndexPath: indexPath) as! NTFeedDetailTableViewCell
            cell.nameLabel.text = feedlogger.name
            cell.headlineLabel.text = feed.headline
            cell.postDetailLabel.text = feed.logDetail
            cell.commentBtn.addTarget(self, action: "addComment:", forControlEvents: .TouchUpInside)
            cell.likeBtn.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
            if feed.numberOfComment == 0 {
                cell.numberOfComment.hidden = true
            }else {
                cell.numberOfComment.text = String(feed.numberOfComment) + " Comment"
            }
            if feed.likes == 0 {
                cell.numberOfLikes.hidden = true
            }else {
                cell.numberOfLikes.text = String(feed.likes) + " Like"
            }
            cell.profileImageView.sd_setImageWithURL(NSURL(string:
                feedlogger.picture!), placeholderImage: UIImage(named: "defaultImage"))
            if feed.logImage.isEmpty {
                cell.postImageLabel?.image = UIImage(named: "flag")
            }else {
                let decodedImageData = NSData(base64EncodedString: feed.logImage, options: NSDataBase64DecodingOptions(rawValue: 0))
                cell.postImageLabel?.image = UIImage(data: decodedImageData!)
            }
            return cell
        }else {
            let cell:NTCommentTableViewCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! NTCommentTableViewCell
            let comment:Comment = combinedArray[indexPath.row] as! Comment
            cell.bodyLabel.text = comment.comment
            cell.nameLabel.text = comment.commentOwnerName
            cell.profileImageView.sd_setImageWithURL(NSURL(string:
                comment.commentOwnerPic), placeholderImage: UIImage(named: "defaultImage"))
          return cell
        }
        
    }
    
    func addComment(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NTAddCommentViewController") as! NTAddCommentViewController
        controller.feed = feed
        let navController = UINavigationController(rootViewController: controller)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func like(sender:UIButton) {
        NTFirebaseHelper.shared.updateFeedLike(feed)
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

   
}
