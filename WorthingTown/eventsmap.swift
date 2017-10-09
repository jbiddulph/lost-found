//
//  eventsmap.swift
//  LostFound
//
//  Created by John Biddulph on 01/05/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class eventsmap: UIViewController, CLLocationManagerDelegate {
    
    var ref:DatabaseReference!
    var refHandle: UInt!
    var databaseHandle: DatabaseHandle!
    var events = [Event]()
    
    
    @IBOutlet var myLocation: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var lonLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServiceAuthenticationStatus()
        listPins()
        
        let distancespan:CLLocationDegrees = 500
        mapView.clipsToBounds = true
        mapView.delegate = self
    }
    
    @IBAction func zoomOnMe(_ sender: UIButton) {
        let myLat = locationManager.location?.coordinate.latitude
        let myLon = locationManager.location?.coordinate.longitude
        let initialLocation = CLLocation(latitude: myLat!, longitude: myLon!)
        
        zoomMapOn(location: initialLocation)
    }
    
    
    private let regionRadius: CLLocationDistance = 1000 //1km
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0 )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Current Location
    var locationManager = CLLocationManager()
    func checkLocationServiceAuthenticationStatus() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Show Direction
    
    var currentPlacemark: CLPlacemark?
    
    @IBAction func showDirection(sender:Any) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirectionsRequest()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking
        
        //calculate directions
        let directions  = MKDirections(request: directionRequest)
        directions.calculate { (directionsResponse, error) in
            guard let directionsResponse = directionsResponse else {
                if let error = error {
                    print("Error, getting directions: \(error.localizedDescription) ")
                }
                return
            }
            
            let route  = directionsResponse.routes[0]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let routeRect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(routeRect), animated: true)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startObservingDB(){
        
        ref.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newEvent = [Event]()
            
            
            for event in snapshot.children.allObjects{
                let eventObject = Event(snapshot: event as! DataSnapshot)
                newEvent.append(eventObject)
                let latitude = eventObject.rsLat
                let longitude = eventObject.rsLon
                //self.latLabel.text = Double(latitude!) ?? 0.0
                //self.lonLabel.text = Double(longitude!) ?? 0.0
            }
            
            self.events = newEvent
            
            
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
                            let lonName = name["rsLon"] as? String {
                            let latitude = Double(latName) ?? 0.0
                            let longitude = Double(lonName) ?? 0.0
                            
                            let theTitle = name["rsEvent"] as? String
                            let subTitle = name["rsEventDate"] as? String
                            
                            
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
    
    
}

extension eventsmap {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    
}
extension eventsmap : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? mapAnnotation {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier:identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as! UIView
            }
            return view
            
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location  = view.annotation as! mapAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation as? mapAnnotation {
            self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(r: 250, g: 175, b: 0)
        renderer.lineWidth = 4.0
        return renderer
    }
}
