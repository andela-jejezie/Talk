//
//  Firebase.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 09/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import Foundation

private let _sharedNTFirebaseHelper = NTFirebaseHelper()

class NTFirebaseHelper {
    class var shared: NTFirebaseHelper {
        return _sharedNTFirebaseHelper
    }
    
    lazy var usersRef: Firebase? = {
        return Firebase(url:"https://naijatalk.firebaseio.com/").childByAppendingPath("users")
    }()
    
    lazy var logsRef: Firebase? = {
        return Firebase(url:"https://naijatalk.firebaseio.com/").childByAppendingPath("logs")
    }()
    
    lazy var ref: Firebase? = {
        return Firebase(url:"https://naijatalk.firebaseio.com/")
    }()
    
    lazy var commentsRef: Firebase? = {
        return Firebase(url:"https://naijatalk.firebaseio.com/").childByAppendingPath("comments")
    }()
    
    lazy var dateToString: String? = {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormater.stringFromDate(NSDate())
    }()

    
    var sharedUser:NTUser!
    
    func saveProviderData(userProfile:[String:AnyObject], provider:String) -> NTUser {
        
        
        let userRef = usersRef!.childByAppendingPath(userProfile["id"] as! String)
        let user: NTUser?
        if (provider == "google") {
            user = NTUser(name: userProfile["name"] as! String, email:userProfile["email"] as? String, gender: userProfile["gender"] as! String, uid: userProfile["id"] as! String, picture:userProfile["picture"] as? String, stateOfOrigin:"", job:"", stateOfResidence:"", createdDate:dateToString!)
            
            
        }
        else {
            user = NTUser(name: userProfile["name"] as! String, email:userProfile["email"] as? String, gender: userProfile["gender"] as! String, uid: userProfile["id"] as! String, picture:userProfile["picture"]!["data"]!!["url"] as? String, stateOfOrigin:"", job:"", stateOfResidence:"", createdDate:dateToString!)
        }
        userRef.setValue(user!.toAnyObject())
        let userdefault = NSUserDefaults()
        userdefault.setObject(userProfile["id"] as! String, forKey: "ntUserUid")
        
        return user!
    }
    
    func updateFeedLike(feed:NTlogs) {
        var numLike = feed.likes
        numLike++
        let feedRef = NTFirebaseHelper.shared.logsRef?.childByAppendingPath(feed.postLogger).childByAppendingPath(feed.uid)
        let update = [
            "likes":numLike
        ]
        feedRef?.updateChildValues(update)
    }
    

    
    
}
