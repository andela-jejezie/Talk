//
//  NTLogs.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 10/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import Foundation

class NTlogs {
    
    let postLogger:String!
    let uid:String!
    let headline: String!
    let location: String!
    let logDetail: String!
    let logImage: String!
    let createdDate: String!
    var likes: Int = 0
    var numberOfComment: Int = 0
    
    init(postLogger:String, uid:String, headline:String, location:String, logDetails:String, logImage:String?, date:String, likes:Int?, numberOfComment:Int?){
        self.postLogger = postLogger
        self.uid = uid
        self.headline = headline
        self.location = location
        self.logDetail = logDetails
        if let image:String = logImage {
            self.logImage = image
        }else {
            self.logImage = ""
        }
        
        self.createdDate = date
        if let logLikes = likes {
            self.likes = logLikes
        }
        if let numComment = numberOfComment {
            self.numberOfComment = numComment
        }
    }
    
    init(snapshot:FDataSnapshot!) {
        
        postLogger = snapshot.value.objectForKey("postLogger") as! String
        headline = snapshot.value.objectForKey("headline") as? String
        location = snapshot.value.objectForKey("location") as! String
        uid = snapshot.value.objectForKey("uid") as! String
        logDetail = snapshot.value.objectForKey("logDetail") as? String
        logImage = snapshot.value.objectForKey("logImage") as? String
        likes = (snapshot.value.objectForKey("likes") as? Int)!
        numberOfComment = (snapshot.value.objectForKey("numberOfComment") as? Int)!
        createdDate = snapshot.value.objectForKey("date") as! String
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "postLogger": postLogger,
            "uid": uid,
            "headline": headline,
            "location": location,
            "logDetail": logDetail,
            "logImage":logImage,
            "date":createdDate,
            "likes":likes,
            "numberOfComment":numberOfComment
        ]
    }
    
    
}
