//
//  LoginViewController.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 09/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit
import Google
import FBSDKLoginKit

class NTLoginViewController: UIViewController,FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet var googleSignInButton: GIDSignInButton!

    @IBOutlet var facebookSignInButton: FBSDKLoginButton!
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        let progressHUD = ProgressHUD(text: "Connecting...")
        facebookSignInButton.hidden = true
        googleSignInButton.hidden = true
        self.view.addSubview(progressHUD)
        progressHUD.show()
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            NTFirebaseHelper.shared.ref!.authWithOAuthProvider("facebook", token: FBSDKAccessToken.currentAccessToken().tokenString, withCompletionBlock: { (fbError:NSError!, fbAuthData:FAuthData!) -> Void in
                if let userProfile:[String:AnyObject] = fbAuthData.providerData["cachedUserProfile"] as? [String: AnyObject] {
                    
                    let userRef =  NTFirebaseHelper.shared.usersRef?.childByAppendingPath(userProfile["id"] as! String)
                    userRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
                        userRef?.removeAllObservers();
                        if  (snapshot.exists()) {
                            
                            print("this is authdata \(snapshot) ")
                            NTFirebaseHelper.shared.sharedUser = NTUser(snapshot: snapshot)
                            let userdefault = NSUserDefaults()
                            userdefault.setObject(userProfile["id"] as! String, forKey: "ntUserUid")
                            progressHUD.hide()
                            self.performSegueWithIdentifier("LoginToTabBar", sender: nil)
                            
                        }else {
                            print("this is authdata \(snapshot.value) ")
                            NTFirebaseHelper.shared.sharedUser = NTFirebaseHelper.shared.saveProviderData(userProfile, provider: fbAuthData.provider)
                            progressHUD.hide()
                            self.performSegueWithIdentifier("loginToUpdateSegue", sender: nil)
                            
                        }
                    })
                    
                    
                }
            })
        }
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progressHUD = ProgressHUD(text: "Connecting...")
        
        self.view.backgroundColor = UIColor(red: 0.34, green: 0.41, blue: 0.47, alpha: 1);
        let path = NSBundle.mainBundle().pathForResource("GoogleService-Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path!)
        let googleSignIn = GIDSignIn.sharedInstance();
        googleSignIn.clientID = plist?.objectForKey("CLIENT_ID") as! String
        googleSignIn.delegate = self
        googleSignIn.uiDelegate = self
        facebookSignInButton.delegate = self
//        googleSignIn.signIn()
        // Create and add the view to the screen.
        GIDSignIn.sharedInstance().delegate = self
        
//
        
       
        let userdefault = NSUserDefaults()
        if let userUid = userdefault.valueForKey("ntUserUid") as? String{
            self.view.addSubview(progressHUD)
            print(userUid)
            if !userUid.isEmpty {
                facebookSignInButton.hidden = true
                googleSignInButton.hidden = true
                progressHUD.show()
                let userRef =  NTFirebaseHelper.shared.usersRef?.childByAppendingPath(userUid)
                userRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
                    userRef?.removeAllObservers();
                    if  (snapshot.exists()) {
                        
                        print("this is authdata \(snapshot) ")
                        NTFirebaseHelper.shared.sharedUser = NTUser(snapshot: snapshot)
                        progressHUD.hide()
                        self.performSegueWithIdentifier("LoginToTabBar", sender: nil)
                        
                    }else {
                        progressHUD.hide()
                        
                    }
                })
            }
        }
//        progressHUD.hide()
        
       
        
        // Do any additional setup after loading the view.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        let progressHUD = ProgressHUD(text: "Connecting...")
        facebookSignInButton.hidden = true
        googleSignInButton.hidden = true
        self.view.addSubview(progressHUD)
        progressHUD.show()
        if error != nil {
            progressHUD.hide()
            print("error occured \(error)")
        }else {
            print("successful \(user) ")
            NTFirebaseHelper.shared.ref!.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error:NSError!, authData:FAuthData!) -> Void in
                if let userProfile:[String:AnyObject] = authData.providerData["cachedUserProfile"] as? [String: AnyObject] {
                    
                    let userRef =  NTFirebaseHelper.shared.usersRef?.childByAppendingPath(userProfile["id"] as! String)
                    userRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
                        userRef?.removeAllObservers();
                        if  (snapshot.exists()) {
                            
                            print("this is authdata \(snapshot) ")
                            NTFirebaseHelper.shared.sharedUser = NTUser(snapshot: snapshot)
                            let userdefault = NSUserDefaults()
                            userdefault.setObject(userProfile["id"] as! String, forKey: "ntUserUid")
                            progressHUD.hide()
                            self.performSegueWithIdentifier("LoginToTabBar", sender: nil)
                            
                        }else {
                            print("this is authdata \(snapshot.value) ")
                            NTFirebaseHelper.shared.sharedUser = NTFirebaseHelper.shared.saveProviderData(userProfile, provider: authData.provider)
                            progressHUD.hide()
                            self.performSegueWithIdentifier("loginToUpdateSegue", sender: nil)
                            
                        }
                    })
                }

            })
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    }
    
}
