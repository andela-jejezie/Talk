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
import TwitterKit

class NTLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    typealias APICallback = ((FAuthData?, NSError?) -> ())


    @IBAction func loginWithGoogle(sender: AnyObject) {
        let path = NSBundle.mainBundle().pathForResource("GoogleService-Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path!)
        let googleSignIn = GIDSignIn.sharedInstance();
        googleSignIn.clientID = plist?.objectForKey("CLIENT_ID") as! String
        googleSignIn.delegate = self
        googleSignIn.uiDelegate = self
        googleSignIn.signIn()
        
    }
    
    
    @IBAction func loginWithTwitter(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { (session:TWTRSession?, error:NSError?) -> Void in
            if (session != nil) {
                print("signed in as \(session!.authToken)")
                let authParameters: [NSObject : AnyObject] = [
                    "user_id":session!.userID,
                    "oauth_token":session!.authToken,
                    "oauth_token_secret":session!.authTokenSecret
                ]
                NTFirebaseHelper.shared.ref!.authWithOAuthProvider("twitter", parameters: authParameters, withCompletionBlock: { (twAuthError:NSError!, twAuthData:FAuthData!) -> Void in
                    print("firebase error \(twAuthError.description)")
                    print("this is authdata \(twAuthData.providerData) ")
                })
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    @IBAction func loginWithFacebook(sender: AnyObject) {
        let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            print("error \(error)")
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
                                self.performSegueWithIdentifier("LoginToTabBar", sender: nil)
                                
                            }else {
                                print("this is authdata \(snapshot.value) ")
                                NTFirebaseHelper.shared.sharedUser = NTFirebaseHelper.shared.saveProviderData(userProfile, provider: fbAuthData.provider)
                                self.performSegueWithIdentifier("loginToUpdateSegue", sender: nil)
                                
                            }
                        })

                        
                    }
                })
            }
   
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userdefault = NSUserDefaults()
        if let userUid = userdefault.valueForKey("ntUserUid") as? String{
            print(userUid)
            if !userUid.isEmpty {
                let userRef =  NTFirebaseHelper.shared.usersRef?.childByAppendingPath(userUid)
                userRef?.observeEventType(.Value, withBlock: { (snapshot:FDataSnapshot!) -> Void in
                    userRef?.removeAllObservers();
                    if  (snapshot.exists()) {
                        
                        print("this is authdata \(snapshot) ")
                        NTFirebaseHelper.shared.sharedUser = NTUser(snapshot: snapshot)
                        self.performSegueWithIdentifier("LoginToTabBar", sender: nil)
                        
                    }
                })
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            print("error occured \(error)")
        }else {
            print("successful \(user) ")
            NTFirebaseHelper.shared.ref!.authWithOAuthProvider("google", token: user.authentication.accessToken, withCompletionBlock: { (error:NSError!, authData:FAuthData!) -> Void in
                if let _:[String:AnyObject] = authData.providerData["cachedUserProfile"] as? [String: AnyObject] {
                    
                }
//                if error == nil {
//                    
//                    print("this is authdata \(authData.providerData["cachedUserProfile"]) ")
//                }
            })
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    }
    
}
