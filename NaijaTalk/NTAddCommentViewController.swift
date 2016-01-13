//
//  NTAddCommentViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 12/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTAddCommentViewController: UIViewController {

    @IBOutlet var commentBtn: UIButton!
    
    @IBOutlet var commentTextView: UITextView!
    var feed: NTlogs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.becomeFirstResponder()
        commentBtn.addTarget(self, action: "postComment:", forControlEvents: .TouchUpInside)
        commentBtn.backgroundColor = UIColor(red: 0.15, green: 0.81, blue: 0.35, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        commentBtn.layer.cornerRadius = 5
        commentBtn.clipsToBounds = true
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentTextView.layer.cornerRadius = 2
        commentTextView.clipsToBounds = true
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func postComment(sender:UIButton) {
        if ((commentTextView.text?.isEmpty) == true) {
            let alert = UIAlertController(title: "", message: "Comment can not be empty", preferredStyle: UIAlertControllerStyle.Alert)
           let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
           })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
            self.post()

    }
    
    func post(){
        let activityIndicator = ProgressHUD(text: "Saving...")
        self.view.addSubview(activityIndicator)
        activityIndicator.show()
        NTFirebaseHelper.shared.updateNumOfComment(feed)
        let commentRef = NTFirebaseHelper.shared.commentsRef?.childByAppendingPath(feed.uid).childByAutoId()
        let comment = Comment(comment: commentTextView.text!, commentOwnerID: NTFirebaseHelper.shared.sharedUser.uid, postCommentedID: feed.uid, commentOwnerName: NTFirebaseHelper.shared.sharedUser.name, commentOwnerPic: NTFirebaseHelper.shared.sharedUser.picture!, createdDate: NTFirebaseHelper.shared.dateToString!)
        commentRef?.setValue(comment.toAnyObject(), withCompletionBlock: { (error:NSError!, firebase:Firebase!) -> Void in
            if error != nil {
                print("error occurred \(error)")
               activityIndicator.hide()
            }else {
                print("success")
                activityIndicator.hide()
                 self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }

}
