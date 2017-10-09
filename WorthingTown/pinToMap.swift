//
//  pinToMap.swift
//  LostFound
//
//  Created by John Biddulph on 22/05/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class pinToMap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var circleRenderer = MKCircleRenderer()
    let manager = CLLocationManager()
    var centermap = ""
    var foundlostHeader = String()
    var mapLatitude = CGFloat()
    var mapLonitude = CGFloat()
    var areasize = 100
    var thelocationName = String()
    var locationName = String()
    var city = String()
    var thecity = String()
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapZoomControl: UISwitch!
    @IBOutlet var eventStatus: UILabel!
    @IBOutlet var TargetGridReference: UILabel!
    @IBOutlet var latLnglbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        if(foundlostHeader == "Lost"){
            navigationController?.navigationBar.barTintColor = UIColor.red
        } else if(foundlostHeader == "Found"){
            navigationController?.navigationBar.barTintColor = UIColor.green
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        self.mapView.isZoomEnabled = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.hideKeyboardWhenTappedAround()
        
        
        self.title = foundlostHeader
        //circle movement
        let circleView = UIView()
        if(foundlostHeader == "Lost") {
            eventStatus.text = "Lost"
            circleView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        } else {
            eventStatus.text = "Found"
            circleView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        mapView.addSubview(circleView)
        mapView.bringSubview(toFront: circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(areasize))
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(areasize))
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        let mapcentrelat = mapView.bounds.size.width
        let mapcenterlon = mapView.bounds.size.height
        print("map Lat Long centered: \(mapcentrelat) and \(mapcenterlon)")
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.mapView.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.frame.width/2
            circleView.clipsToBounds = true
            //let centrelat = self.mapView.centerXAnchor
            //let centerlon = self.mapView.centerYAnchor
            //print("Lat Long centered: \(centrelat) and \(centerlon)")
        })
        
        let mylat = manager.location?.coordinate.latitude
        let mylon = manager.location?.coordinate.longitude
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        
        mapLatitude = CGFloat(center.latitude)
        mapLonitude = CGFloat(center.longitude)
        let latAndLong = "Lat: \(mapLatitude) Long: \(mapLonitude)"
        
        //self.TargetGridReference.text = latAndLong
        self.latLnglbl.text = latAndLong
        

    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations[locations.count - 1]
        //let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            
            print("location ", location)
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            
            self.mapView.centerCoordinate = location.coordinate
            
            let addr = loc.locality!   // it is optional !
            print("locality ", addr)
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 750, 750)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
            
            guard let addressDict = placeMarks[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach {
                
                print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            self.locationName = (addressDict["Name"] as? String)!
            print(self.locationName)
            self.TargetGridReference.text = (addressDict["City"] as? String)!
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            self.thecity = (addressDict["City"] as? String)!
                print(self.thecity)
            self.thelocationName = self.thecity
            
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            if let country = addressDict["Country"] as? String {
                print(country)
            }
            
            
            
        })
        //self.TargetGridReference.text = "name: "+thelocationName
        // We use a predefined location
        //var centerlocation = CLLocation(latitude: manager.location?.coordinate.latitude as! CLLocationDegrees, longitude: manager.location?.coordinate.longitude as! CLLocationDegrees)
        manager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLatLon" {
            let addViewController: NewEventViewController = segue.destination as! NewEventViewController
            addViewController.itemmapLatitude = mapLatitude
            addViewController.itemmapLonitude = mapLonitude
            addViewController.foundlostHeader = foundlostHeader
            addViewController.thelocationName = thelocationName
        }
        
        
    }
    
    
    @IBAction func zoomControlSwitch(_ sender: Any) {
        if(mapZoomControl.isOn){
            self.mapView.isZoomEnabled = false
            let alert = UIAlertController(title: "Zoom Locked", message: "This is locked by default to show the area in which the item was lost, by default this is set to 50 meters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.mapView.isZoomEnabled = true
            let alert = UIAlertController(title: "Warning!", message: "Unlocking map zoom is for interaction purposes only, location will be set to center of circle", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
