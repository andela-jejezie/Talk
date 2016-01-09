//
//  NTUserProfileUpdateViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 09/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTUserProfileUpdateViewController: UIViewController {

    @IBOutlet var updateLaterBtn: UIButton!
    @IBOutlet var updateNowBtn: UIButton!
    @IBOutlet var stateOfResidenceTextField: UITextField!
    @IBOutlet var stateOfOriginTextField: UITextField!
    @IBOutlet var jobTextField: UITextField!
    @IBOutlet var welcomeMessageLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height/2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.sd_setImageWithURL(NSURL(string:
            NTFirebaseHelper.shared.sharedUser.picture!), placeholderImage: UIImage(named: "defaultImage"))
        let name = NTFirebaseHelper.shared.sharedUser.name
        let nameArray = name.componentsSeparatedByString(" ")
        welcomeMessageLabel.text = "Welcome " + nameArray[0]
        updateNowBtn.layer.cornerRadius = 5
        updateLaterBtn.layer.cornerRadius = 5
        updateLaterBtn.clipsToBounds = true
        updateNowBtn.clipsToBounds = true
        
    }
    

    @IBAction func updateNow(sender: AnyObject) {
        let user:NTUser = NTUser(name: NTFirebaseHelper.shared.sharedUser.name, email: NTFirebaseHelper.shared.sharedUser.email, gender: NTFirebaseHelper.shared.sharedUser.gender, uid: NTFirebaseHelper.shared.sharedUser.uid, picture: NTFirebaseHelper.shared.sharedUser.picture, stateOfOrigin: self.stateOfOriginTextField.text, job: self.jobTextField.text, stateOfResidence: self.stateOfResidenceTextField.text)
        let userRef = NTFirebaseHelper.shared.usersRef?.childByAppendingPath(user.uid)
        userRef?.setValue(user.toAnyObject())
    }


    @IBAction func updateLater(sender: AnyObject) {
    }
}
