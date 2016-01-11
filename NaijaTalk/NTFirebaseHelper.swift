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
        
        return user!
    }
    
    // Helper function to turn a snapshot into a dictionary for easier access
    func snapshotToUserObject(snapshot: FDataSnapshot) -> NTUser {
        let userObject : NTUser = NTUser(name: snapshot.value.objectForKey("name") as! String, email: snapshot.value.objectForKey("email") as? String, gender: snapshot.value.objectForKey("gender") as! String, uid: snapshot.value.objectForKey("uid") as! String, picture: snapshot.value.objectForKey("picture") as? String, stateOfOrigin: snapshot.value.objectForKey("stateOfOrigin") as? String, job: snapshot.value.objectForKey("job") as? String, stateOfResidence: snapshot.value.objectForKey("stateOfResidence") as? String, createdDate:snapshot.value.objectForKey("createdDate") as! String)
        
        return userObject
    }
    
    
}
