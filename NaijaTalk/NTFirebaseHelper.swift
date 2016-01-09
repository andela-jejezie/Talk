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
        return Firebase(url:"https://naijatalk.firebaseio.com/").childByAppendingPath("user")
    }()
    
    lazy var ref: Firebase? = {
        return Firebase(url:"https://naijatalk.firebaseio.com/")
    }()

    
    var sharedUser:NTUser!
    
    func saveProviderData(userProfile:[String:AnyObject], provider:String) -> NTUser {
        let usersRef = ref!.childByAppendingPath("user")
        
        let userRef = usersRef.childByAppendingPath(userProfile["id"] as! String)
        let user: NTUser?
        if (provider == "google") {
            user = NTUser(name: userProfile["name"] as! String, email:userProfile["email"] as? String, gender: userProfile["gender"] as! String, uid: userProfile["id"] as! String, picture:userProfile["picture"] as? String, stateOfOrigin:"", job:"", stateOfResidence:"")
        }
        else {
            user = NTUser(name: userProfile["name"] as! String, email:userProfile["email"] as? String, gender: userProfile["gender"] as! String, uid: userProfile["id"] as! String, picture:userProfile["picture"]!["data"]!!["url"] as? String, stateOfOrigin:"", job:"", stateOfResidence:"")
        }
        userRef.setValue(user!.toAnyObject())
        
        return user!
    }
    
    /* Helper function to turn a snapshot into a dictionary for easier access */
    //    func snapshotToDictionary(snapshot: FDataSnapshot) -> Dictionary<String, Any> {
    //        var d = Dictionary<String, Any>()
    //
    //        d["routeTag"] = snapshot.value.objectForKey("routeTag") as String
    //        d["heading"] = snapshot.value.objectForKey("heading") as Int
    //        d["id"] = snapshot.value.objectForKey("id") as Int
    //        d["lat"] = snapshot.value.objectForKey("lat") as Double
    //        d["lon"] = snapshot.value.objectForKey("lon") as Double
    //        d["predictable"] = snapshot.value.objectForKey("predictable") as Bool
    //        d["secsSinceReport"] = snapshot.value.objectForKey("secsSinceReport") as Int
    //        d["speedKmHr"] = snapshot.value.objectForKey("speedKmHr") as Int
    //        d["timestamp"] = snapshot.value.objectForKey("timestamp") as Double
    //        d["vtype"] = snapshot.value.objectForKey("vtype") as String
    //
    //        if snapshot.value.objectForKey("dirTag") {
    //            d["dirTag"] = snapshot.value.objectForKey("dirTag") as String // Sometimes missing
    //        } else {
    //            d["dirTag"] = "OB"
    //        }
    //        
    //        return d
    //    }
    
    
}
