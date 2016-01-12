//
//  NTCreateFeedViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit

class NTCreateFeedViewController: UIViewController, MBProgressHUDDelegate, UITabBarControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var postLogBtn: UIButton!
    @IBOutlet var uploadPicBtn: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var topicTextField: UITextField!
    let picker = UIImagePickerController()
    var imageBase64 = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        uploadPicBtn.addTarget(self, action: "imageUploadActionSheet:", forControlEvents: .TouchUpInside)
        postLogBtn.addTarget(self, action: "postToDatabase:", forControlEvents: .TouchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        postLogBtn.backgroundColor = UIColor(red: 0.15, green: 0.81, blue: 0.35, alpha: 1)
        uploadPicBtn.backgroundColor = UIColor(red: 241/250, green: 241/250, blue: 241/250, alpha: 1)
        postLogBtn.layer.cornerRadius = 5
        postLogBtn.clipsToBounds = true
        
        uploadPicBtn.layer.cornerRadius = 5
        uploadPicBtn.clipsToBounds = true
    }
    
    
    func postToDatabase(sender: AnyObject) {
        let spinner = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.view.addSubview(spinner)
        spinner.mode = MBProgressHUDMode.Indeterminate
        spinner.delegate = self
        spinner.labelText = "Saving"
        spinner.detailsLabelText = "Just a second :)"
        spinner.square = true
        spinner.showAnimated(true, whileExecutingBlock: { () -> Void in
            self.post()
            }) { () -> Void in
                self.tabBarController?.selectedIndex = 1
        }
    }
    
    func post(){
        let userLogRef = NTFirebaseHelper.shared.logsRef?.childByAppendingPath(NTFirebaseHelper.shared.sharedUser.uid)
        let logRef = userLogRef?.childByAutoId()
        let log:NTlogs = NTlogs(postLogger: NTFirebaseHelper.shared.sharedUser.uid, uid: (logRef?.key)!, headline: topicTextField.text!, location:locationTextField.text! , logDetails: descriptionTextView.text, logImage: imageBase64, date: NTFirebaseHelper.shared.dateToString!, likes: 0, numberOfComment: 0)
        logRef!.setValue(log.toAnyObject()) { (fbError:NSError!, firebase:Firebase!) -> Void in
            if fbError == nil {
                
            }else {
                print("error \(fbError.description)")
            }
            
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }

}

extension NTCreateFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func photoFromLibrary(){
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .FullScreen
        presentViewController(picker, animated: true, completion: nil)

    }
    
    func imageUploadActionSheet(sender:AnyObject) {
        let actionSheetAlertController:UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction) -> Void in
            
        }
        actionSheetAlertController.addAction(cancelAction)
        
        let takePhotoAction:UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (action:UIAlertAction) -> Void in
            self.photoFromCamera()
        }
        actionSheetAlertController.addAction(takePhotoAction)
        
        let libraryPhotoAction:UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default) { (action) -> Void in
            self.photoFromLibrary()
        }
        actionSheetAlertController.addAction(libraryPhotoAction)
        
        actionSheetAlertController.popoverPresentationController?.sourceView = sender as? UIView
        
        //Present the AlertController
        self.presentViewController(actionSheetAlertController, animated: true, completion: nil)
    }
    
    
    func photoFromCamera() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = .Camera
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }else {
            noCamera()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleToFill
        imageView.image = chosenImage
        let imageData = UIImageJPEGRepresentation(chosenImage, 0.5)
        imageBase64 = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)))!
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }
}
