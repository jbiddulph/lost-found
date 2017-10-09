//
//  sweet.swift
//  thisworthing
//
//  Created by John Biddulph on 06/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:DatabaseReference?
    
    init(content:String, addedByUser:String, Key:String = ""){
        self.key = Key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        if let sweetContent = snapshotValue?["content"] as? String {
            content = sweetContent
        } else {
            content = ""
        }
        
        let snapshotValue1 = snapshot.value as? NSDictionary
        if let sweetUser = snapshotValue1?["addedByUser"] as? String {
            addedByUser = sweetUser
        } else {
            addedByUser = ""
        }
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["content":content as AnyObject, "addedByUser":addedByUser as AnyObject]
    }
}
