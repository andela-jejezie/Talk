//
//  NTUser.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 09/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import Foundation

class NTUser {
    
    let name: String!
    let email: String!
    let gender: String!
    let uid: String!
    let picture: String?
    let stateOfOrigin: String?
    let stateOfResidence: String?
    let job: String!
    let createdDate: String!
    
    init(name:String, email:String?, gender:String, uid:String, picture:String?, stateOfOrigin:String?, job:String?, stateOfResidence:String?, createdDate:String) {
        self.name = name
        if let emailAddress:String = email {
           self.email = emailAddress
        }else {
            self.email = ""
        }
        self.gender = gender
        self.uid = uid
        if let image: String = picture {
            self.picture = image
        }else {
          self.picture = ""
        }
        if let userOrigin:String = stateOfOrigin {
            self.stateOfOrigin = userOrigin
        }else {
           self.stateOfOrigin = ""
        }
        if let userResidence:String = stateOfResidence {
            self.stateOfResidence = userResidence
        }else {
            self.stateOfResidence = ""
        }
        if let userJob:String = job {
            self.job = userJob
        }else {
            self.job = ""
        }
        self.createdDate = createdDate
        
        
    }
    
    init(snapshot:FDataSnapshot!) {
        name = snapshot.value.objectForKey("name") as! String
        email = snapshot.value.objectForKey("email") as? String
        gender = snapshot.value.objectForKey("gender") as! String
        uid = snapshot.value.objectForKey("uid") as! String
        picture = snapshot.value.objectForKey("picture") as? String
        stateOfOrigin = snapshot.value.objectForKey("stateOfOrigin") as? String
        job = snapshot.value.objectForKey("job") as? String
        stateOfResidence = snapshot.value.objectForKey("stateOfResidence") as? String
        createdDate = snapshot.value.objectForKey("createdDate") as! String
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "email": email,
            "gender": gender,
            "uid": uid,
            "picture": picture,
            "job":job,
            "stateOfOrigin":stateOfOrigin,
            "stateOfResidence":stateOfResidence,
            "createdDate":createdDate
        ]
    }
    

    
    
}
