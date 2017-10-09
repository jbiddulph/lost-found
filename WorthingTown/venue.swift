//
//  venue.swift
//  thisworthing
//
//  Created by John Biddulph on 08/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Venue {
    let key:String!
    let rsPubName:String!
    let rsLat:String!
    let rsLong:String!
    let rsPostCode:String!
    let rsTel:String!
    let rsTown:String!
    let rsImageURL:String!
    let rsAddress: String!
    let rsAdd2: String!
    let rsAdd3: String!
    let rsRegion: String!
    let rsWebsite:String!
    let itemRef:DatabaseReference?
    init(rsPubName:String, rsLat:String, rsLong:String, rsPostCode:String, rsTel:String, rsTown:String, rsImageURL:String, rsAddress:String, rsAdd2:String, rsAdd3:String, rsRegion:String, rsWebsite:String, Key:String = ""){
        self.key = Key
        self.rsPubName = rsPubName
        self.rsLat = rsLat
        self.rsLong = rsLong
        self.rsPostCode = rsPostCode
        self.rsTel = rsTel
        self.rsTown = rsTown
        self.rsImageURL = rsImageURL
        self.rsAddress = rsAddress
        self.rsAdd2 = rsAdd2
        self.rsAdd3 = rsAdd3
        self.rsRegion = rsRegion
        self.rsWebsite = rsWebsite
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        if let PubName = snapshotValue?["rsPubName"] as? String {
            rsPubName = PubName
        } else {
            rsPubName = ""
        }
        
        let snapshotValue1 = snapshot.value as? NSDictionary
        if let theLat = snapshotValue1?["rsLat"] as? String {
            rsLat = theLat
        } else {
            rsLat = ""
        }
        
        let snapshotValue2 = snapshot.value as? NSDictionary
        if let theLon = snapshotValue2?["rsLong"] as? String {
            rsLong = theLon
        } else {
            rsLong = ""
        }
        
        
        let snapshotValue4 = snapshot.value as? NSDictionary
        if let Postcode = snapshotValue4?["rsPostCode"] as? String {
            rsPostCode = Postcode
        } else {
            rsPostCode = ""
        }
        
        let snapshotValue5 = snapshot.value as? NSDictionary
        if let theTel = snapshotValue5?["rsTel"] as? String {
            rsTel = theTel
        } else {
            rsTel = ""
        }
        
        let snapshotValue6 = snapshot.value as? NSDictionary
        if let theTown = snapshotValue6?["rsTown"] as? String {
            rsTown = theTown
        } else {
            rsTown = ""
        }
        
        let snapshotValue7 = snapshot.value as? NSDictionary
        if let theImage = snapshotValue7?["rsImageURL"] as? String {
            rsImageURL = theImage
        } else {
            rsImageURL = ""
        }
        
        let snapshotValue8 = snapshot.value as? NSDictionary
        if let theAddress = snapshotValue8?["rsAddress"] as? String {
            rsAddress = theAddress
        } else {
            rsAddress = ""
        }
        
        let snapshotValue9 = snapshot.value as? NSDictionary
        if let theAdd2 = snapshotValue9?["Add2"] as? String {
            rsAdd2 = theAdd2
        } else {
            rsAdd2 = ""
        }
        
        let snapshotValue10 = snapshot.value as? NSDictionary
        if let theAdd3 = snapshotValue10?["Add3"] as? String {
            rsAdd3 = theAdd3
        } else {
            rsAdd3 = ""
        }
        
        let snapshotValue11 = snapshot.value as? NSDictionary
        if let theRegion = snapshotValue11?["rsRegion"] as? String {
            rsRegion = theRegion
        } else {
            rsRegion = ""
        }
        
        let snapshotValue12 = snapshot.value as? NSDictionary
        if let theWebsite = snapshotValue12?["rsWebsite"] as? String {
            rsWebsite = theWebsite
        } else {
            rsWebsite = ""
        }
        
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["rsPubName":rsPubName as AnyObject, "rsLat":rsLat as AnyObject, "rsLong":rsLong as AnyObject, "rsPostCode":rsPostCode as AnyObject, "rsTel":rsTel as AnyObject, "rsTown":rsTown as AnyObject, "rsImageURL":rsImageURL as AnyObject, "rsAddress":rsAddress as AnyObject, "Add2":rsAdd2 as AnyObject, "Add3":rsAdd3 as AnyObject, "rsRegion":rsRegion as AnyObject, "rsWebsite":rsWebsite as AnyObject]
    }
    
}
