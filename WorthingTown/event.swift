//
//  event.swift
//  WorthingTown
//
//  Created by John Biddulph on 01/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Event {
    let key:String!
    let rsEvent:String!
    let rsEventVenue:String!
    let rsEventDate:String!
    let rsEventTime:String!
    let rsEventCategory:String!
    let rsEventPrice:String!
    let rsEventStatus:String!
    let rsEventImage:String!
    let rsLat:String!
    let rsLon:String!
    let rsApproved:String!
    let addedBy:String!
    let itemRef:DatabaseReference?
    
    init(rsEvent:String, rsEventVenue:String, rsEventDate:String, rsEventTime:String, rsEventCategory:String, rsEventPrice:String, rsEventStatus:String, rsEventImage:String, rsLat:String, rsLon:String, rsApproved:String, addedBy:String, Key:String = ""){
        self.key = Key
        self.rsEvent = rsEvent
        self.rsEventVenue = rsEventVenue
        self.rsEventDate = rsEventDate
        self.rsEventTime = rsEventTime
        self.rsEventCategory = rsEventCategory
        self.rsEventPrice = rsEventPrice
        self.rsEventStatus = rsEventStatus
        self.rsEventImage = rsEventImage
        self.rsLat = rsLat
        self.rsLon = rsLon
        self.rsApproved = rsApproved
        self.addedBy = addedBy
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        if let eventTitle = snapshotValue?["rsEvent"] as? String {
            rsEvent = eventTitle
        } else {
            rsEvent = ""
        }
        
        let snapshotValue1 = snapshot.value as? NSDictionary
        if let eventVenue = snapshotValue1?["rsEventVenue"] as? String {
            rsEventVenue = eventVenue
        } else {
            rsEventVenue = ""
        }
        
        let snapshotValue2 = snapshot.value as? NSDictionary
        if let eventDate = snapshotValue2?["rsEventDate"] as? String {
            rsEventDate = eventDate
        } else {
            rsEventDate = ""
        }
        
        let snapshotValue3 = snapshot.value as? NSDictionary
        if let eventTime = snapshotValue3?["rsEventTime"] as? String {
            rsEventTime = eventTime
        } else {
            rsEventTime = ""
        }
        
        let snapshotValue4 = snapshot.value as? NSDictionary
        if let eventCategory = snapshotValue4?["rsEventCategory"] as? String {
            rsEventCategory = eventCategory
        } else {
            rsEventCategory = ""
        }
        
        let snapshotValue5 = snapshot.value as? NSDictionary
        if let eventPrice = snapshotValue5?["rsEventPrice"] as? String {
            rsEventPrice = eventPrice
        } else {
            rsEventPrice = ""
        }
        
        let snapshotValue6 = snapshot.value as? NSDictionary
        if let eventStatus = snapshotValue6?["rsEventStatus"] as? String {
            rsEventStatus = eventStatus
        } else {
            rsEventStatus = ""
        }
        
        let snapshotValue7 = snapshot.value as? NSDictionary
        if let eventImage = snapshotValue7?["rsEventImage"] as? String {
            rsEventImage = eventImage
        } else {
            rsEventImage = ""
        }
        let snapshotValue8 = snapshot.value as? NSDictionary
        if let eventLat = snapshotValue8?["rsLat"] as? String {
            rsLat = eventLat
        } else {
            rsLat = ""
        }
        let snapshotValue9 = snapshot.value as? NSDictionary
        if let eventLon = snapshotValue9?["rsLon"] as? String {
            rsLon = eventLon
        } else {
            rsLon = ""
        }
        let snapshotValue10 = snapshot.value as? NSDictionary
        if let eventApproved = snapshotValue10?["rsApproved"] as? String {
            rsApproved = eventApproved
        } else {
            rsApproved = ""
        }
        let snapshotValue11 = snapshot.value as? NSDictionary
        if let eventAddedBy = snapshotValue10?["addedBy"] as? String {
            addedBy = eventAddedBy
        } else {
            addedBy = ""
        }
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["rsEvent":rsEvent as AnyObject, "rsEventVenue":rsEventVenue as AnyObject, "rsEventDate":rsEventDate as AnyObject, "rsEventTime":rsEventTime as AnyObject, "rsEventCategory":rsEventCategory as AnyObject, "rsEventPrice":rsEventPrice as AnyObject, "rsEventStatus":rsEventStatus as AnyObject, "rsEventImage":rsEventImage as AnyObject, "rsLat":rsLat as AnyObject, "rsLon":rsLon as AnyObject, "rsApproved":rsApproved as AnyObject, "addedBy":addedBy as AnyObject]
    }
    
}
