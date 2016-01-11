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
    let date: String!
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
        
        self.date = date
        if let logLikes = likes {
            self.likes = logLikes
        }
        if let numComment = numberOfComment {
            self.numberOfComment = numComment
        }
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "postLogger": postLogger,
            "uid": uid,
            "headline": headline,
            "location": location,
            "logDetail": logDetail,
            "logImage":logImage,
            "date":date,
            "likes":likes,
            "numberOfComment":numberOfComment
        ]
    }
    
    
}
