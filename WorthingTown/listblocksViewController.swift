//
//  listblocksViewController.swift
//  thisworthing
//
//  Created by John Biddulph on 16/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class listblocksViewController: UIViewController {

    var ref:DatabaseReference!
    var refHandle: UInt!
    var databaseHandle: DatabaseHandle!
    var venues = [Venue]()
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var lonLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //listPins()
        let londonLat = 50.81787
        let londonLon = -0.37288200000000415
        let distancespan:CLLocationDegrees = 5000
        let worthingLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(londonLat, londonLon)
        
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(worthingLocation, distancespan, distancespan), animated: true)
        mapView.clipsToBounds = true
        let worthingClassPin = mapAnnotation(title: "This is Worthing", subtitle: "Worthing Map", coordinate: worthingLocation, pinTintColor: UIColor.orange, imageName: "marker.png")
        
        //let worthingClassPin = mapAnnotation(title: "This is Worthing", subtitle: "Worthing Map", coordinate: worthingLocation)
        
        mapView.addAnnotation(worthingClassPin)
        
//        ref!.observe(.value, with: { (snapshot) in
//            for child in snapshot.children {
//                let msg = child as! FIRDataSnapshot
//                print("\(msg.key): \(msg.value!)")
//                
//            }
//        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listPins()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startObservingDB(){
        
        ref.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newVenue = [Venue]()
            
            
            for venue in snapshot.children.allObjects{
                let venueObject = Venue(snapshot: snapshot )
                newVenue.append(venueObject)
                let latitude = venueObject.rsLat
                let longitude = venueObject.rsLong
                //self.latLabel.text = Double(latitude!) ?? 0.0
                //self.lonLabel.text = Double(longitude!) ?? 0.0
            }
            
            self.venues = newVenue
            
            
        })
        
    }

    
    func listPins(){
        ref = Database.database().reference().child("events-list").child("worthing-events-list")
        databaseHandle = ref.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            //for child in snapshot.children {
                if let snapDict = snapshot.value as? [String:AnyObject] {
                    
                    for child in snapDict{
                        
                        let shotKey = snapshot.children.nextObject() as! DataSnapshot
                        
                        if let name = child.value as? [String:AnyObject]{
                            if let latName = name["rsLat"] as? String,
                                let lonName = name["rsLong"] as? String {
                                let latitude = Double(latName) ?? 0.0
                                let longitude = Double(lonName) ?? 0.0
                                
                                let theTitle = name["rsPubName"] as? String
                                let subTitle = name["rsTel"] as? String
                                
                                
                                let distancespan:CLLocationDegrees = 5000
                                let theLocations:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(theLocations, distancespan, distancespan), animated: true)
                                let worthingClassPin = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations, pinTintColor: UIColor.green, imageName: "marker.png")
                                //let worthingClassPin = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations)
                                
                                self.mapView.addAnnotation(worthingClassPin)
                            }
                        }
                    }
                    
                }
                
            //}
        })
    }
    
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
