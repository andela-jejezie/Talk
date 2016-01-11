//
//  NTFeedDetailViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 11/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTFeedDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var feedLocationLabel: UILabel!
    @IBOutlet var feedLoggerNameLabel: UILabel!
    @IBOutlet var feedTextView: UITextView!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedHeadlineLabel: UILabel!
    
    var feed:NTlogs!
    var logger:NTUser!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        feedHeadlineLabel.text = feed.headline
        feedLocationLabel.text = feed.location
        feedTextView.text = feed.logDetail
        feedLoggerNameLabel.text = logger.name
        
        if feed.logImage.isEmpty {
            feedImageView?.image = UIImage(named: "flag")
        }else {
            let decodedImageData = NSData(base64EncodedString: feed.logImage, options: NSDataBase64DecodingOptions(rawValue: 0))
            feedImageView?.image = UIImage(data: decodedImageData!)
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

}
extension NTFeedDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
