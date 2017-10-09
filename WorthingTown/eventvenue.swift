//
//  eventvenue.swift
//  WorthingTown
//
//  Created by John Biddulph on 03/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Eventvenue {
    let key:String!
    let rsEventVenue:String!
    let itemRef:DatabaseReference?
    
    init(rsEventVenue:String, Key:String = ""){
        self.key = Key
        self.rsEventVenue = rsEventVenue
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue1 = snapshot.value as? NSDictionary
        if let eventVenue = snapshotValue1?["rsEventVenue"] as? String {
            rsEventVenue = eventVenue
        } else {
            rsEventVenue = ""
        }
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["rsEventVenue":rsEventVenue as AnyObject]
    }
}
