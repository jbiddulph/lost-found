//
//  user.swift
//  thisworthing
//
//  Created by John Biddulph on 06/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//



import Foundation
import FirebaseDatabase

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

