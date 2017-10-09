//
//  mapAnnotation.swift
//  thisworthing
//
//  Created by John Biddulph on 16/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import MapKit
import Contacts

class mapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var pinTintColor: UIColor!
    var imageName: String!
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D, pinTintColor: UIColor, imageName: String){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.pinTintColor = pinTintColor
        self.imageName = imageName
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey):
            subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(title!) \(subtitle!)"
        
        return mapItem
    }
    
}
