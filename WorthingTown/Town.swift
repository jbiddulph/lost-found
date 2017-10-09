//
//  Town.swift
//  LostFound
//
//  Created by John Biddulph on 27/06/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Town {
    let key:String!
    let theTown:String!
    let itemRef:DatabaseReference?
    
    init(theTown:String, Key:String = ""){
        self.key = Key
        self.theTown = theTown
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        if let townContent = snapshotValue?["townName"] as? String {
            theTown = townContent
        } else {
            theTown = ""
        }
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["townName":theTown as AnyObject]
    }
}
