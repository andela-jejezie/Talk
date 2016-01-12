//
//  Comment.swift
//  NaijaTalk
//
//  Created by Johnson Ejezie on 12/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import Foundation

class Comment {
    
    let comment:String!
    let commentOwnerID:String!
    let postCommentedID:String!
    let commentOwnerName:String!
    let commentOwnerPic:String!
    let createdDate:String!
    
    init(comment:String, commentOwnerID:String, postCommentedID:String, commentOwnerName:String,commentOwnerPic:String, createdDate:String ) {
        self.comment = comment
        self.commentOwnerID = commentOwnerID
        self.postCommentedID = postCommentedID
        self.commentOwnerName = commentOwnerName
        self.commentOwnerPic = commentOwnerPic
        self.createdDate = createdDate
    }
    
    init(snapshot:FDataSnapshot!) {
        
        comment = snapshot.value.objectForKey("comment") as! String
        commentOwnerID = snapshot.value.objectForKey("commentOwnerID") as? String
        commentOwnerName = snapshot.value.objectForKey("commentOwnerName") as! String
        commentOwnerPic = snapshot.value.objectForKey("commentOwnerPic") as! String
        postCommentedID = snapshot.value.objectForKey("postCommentedID") as? String
  
        createdDate = snapshot.value.objectForKey("createdDate") as! String
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "comment": comment,
            "commentOwnerID": commentOwnerID,
            "commentOwnerName": commentOwnerName,
            "commentOwnerPic": commentOwnerPic,
            "postCommentedID": postCommentedID,
            "createdDate":createdDate,
        ]
    }
    
    
    
    
}