//
//  venueDetails.swift
//  WorthingTown
//
//  Created by John Biddulph on 27/03/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


class venueDetails: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    var polyLineRenderer = MKPolylineRenderer()
    var myRoute : MKRoute!
    var ref:DatabaseReference!
    var refHandle: UInt!
    var databaseHandle: DatabaseHandle!
    var venue :Venue!
    var events = [Event]()
    var latitude = Double()
    var longitude = Double()
    var londonLat = Double()
    var londonLon = Double()
    //var venueImage :UIImageView!
    //var venueImage1 :UIImageView!
    let manager = CLLocationManager()
    
    
    
    @IBOutlet var distance: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var pubName: UILabel!
    @IBOutlet var postCode: UILabel!
    @IBOutlet var telephone: UILabel!
    @IBOutlet var venueImage: UIImageView!
    @IBOutlet var venueImage1: UIImageView!
    @IBOutlet var noofEvents: UILabel!
    @IBOutlet var eventsAtVenue: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapView.userTrackingMode = .follow
        self.mapView.showsUserLocation = true
        
        let londonLat = self.manager.location?.coordinate.latitude
        let londonLon = self.manager.location?.coordinate.longitude
        //let londonLat = 50.81787
        //let londonLon = -0.37288200000000415
        let distancespan:CLLocationDegrees = 5000
        let worthingLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(londonLat!, londonLon!)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(worthingLocation, distancespan, distancespan), animated: true)
        mapView.clipsToBounds = true
        let worthingClassPin = mapAnnotation(title: "Start Location", subtitle: "This is where I started!", coordinate: worthingLocation, pinTintColor: UIColor.brown, imageName: "marker.png")
        //let worthingClassPin = mapAnnotation(title: "My Location", subtitle: "Here I am!", coordinate: worthingLocation)
        
        mapView.addAnnotation(worthingClassPin)
        
        self.pubName.text = venue.rsPubName
        self.postCode.text = venue.rsPostCode
        self.telephone.text = venue.rsTel
        
        let theImageURL = venue.rsImageURL
        let theImageURL1 = venue.rsImageURL
        
        
        let latName = venue.rsLat as? String
        let lonName = venue.rsLong as? String
            let latitude = Double(latName!) ?? 0.0
            let longitude = Double(lonName!) ?? 0.0
            let theTitle = venue.rsPubName
            let subTitle = venue.rsTel
            let thepostCode = venue.rsPostCode
            
            
            let distancespan1:CLLocationDegrees = 5000
            let theLocations:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(theLocations, distancespan1, distancespan), animated: true)
            
            //let worthingClassPin1 = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations)
            let worthingClassPin1 = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations, pinTintColor: UIColor.purple, imageName: "marker.png")
            self.mapView.addAnnotation(worthingClassPin1)
            venueImage.downloadedFrom(link: theImageURL!)
        venueImage1.downloadedFrom(link: theImageURL1!)
        //venueImage1.layer.cornerRadius = venueImage1.frame.size.height/2
        
        //venueImage1.clipsToBounds = true
        
        //let thedistance = loc.distanceFromLocation(loc)
        
        //let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        manager.requestAlwaysAuthorization()
        let regionRadius = 8.00
        
        let title = venue.rsPubName as? String
        // 3. setup region
        let venueregion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius:regionRadius, identifier: title!)
        
        manager.startMonitoring(for: venueregion)
        let ref = Database.database().reference().child("events-list").child("worthing-events-list")
        let query = ref.queryOrdered(byChild: "rsEventVenue").queryEqual(toValue: venue.key)
        query.observe(.value, with: { (snapshot) in
            var newEvents = [Event]()
            
            
            for event in snapshot.children.allObjects{
                let eventObject = Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            //print("events: \(newEvents)")
            if self.eventsAtVenue.titleLabel?.text == "Events at this venue" {
                self.eventsAtVenue.titleLabel?.text = String(newEvents.count)
            } else {
                self.eventsAtVenue.titleLabel?.text = String(newEvents.count)
            }
            
            self.noofEvents.text = String(newEvents.count)
            if self.noofEvents.text! == "0" {
                self.eventsAtVenue.isHidden = true
                self.noofEvents.isHidden = true
            } else {
                self.eventsAtVenue.isHidden = false
                self.noofEvents.isHidden = false
            }
        })
        
        
    }
    
    
    @IBAction func getDir(_ sender: Any) {
        openMapForPlace()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //manager.stopUpdatingLocation()
        let location = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            
            self.mapView.centerCoordinate = location.coordinate
            let addr = loc.locality
            //self.address.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
            
        })
        let latName = venue.rsLat as? String
        let lonName = venue.rsLong as? String
        let latitude = Double(latName!) ?? 0.0
        let longitude = Double(lonName!) ?? 0.0
        
        let mylat = manager.location?.coordinate.latitude
        let mylon = manager.location?.coordinate.longitude
        
        var one = CLLocation(latitude: mylat!, longitude: mylon!)
        var two = CLLocation(latitude: latitude, longitude: longitude)
        let distance = two.distance(from: one)/1609.344
        self.distance.text = (NSString(format:"%.2f", distance) as String)
    }
    
    @IBAction func showRoute(_ sender: Any) {
       
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(Double(venue.rsLat) ?? 0.0, Double(venue.rsLong) ?? 0.0)
        point1.title = venue.rsPubName
        point1.subtitle = venue.rsAddress
        mapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake((self.manager.location?.coordinate.latitude)!, (self.manager.location?.coordinate.longitude)!)
        //point2.title = "My Location"
        //point2.subtitle = "Here I am!"
        //mapView.addAnnotation(point2)
        mapView.centerCoordinate = point2.coordinate
        mapView.delegate = self
        
        //Span of the map
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.05,0.05)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        let myLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let selectedVenue = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: selectedVenue)
        directionsRequest.destination = MKMapItem(placemark: myLocation)
        
        directionsRequest.transportType = MKDirectionsTransportType.walking
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            
            if error == nil {
                self.myRoute = response!.routes[0] as MKRoute
                self.mapView.add(self.myRoute.polyline)
            }
            
        })
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor(r: 37, g: 108, b: 162)
        myLineRenderer.lineWidth = 4
        return myLineRenderer
        
    }
    
    func openMapForPlace() {
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(Double(venue.rsLat) ?? 0.0, Double(venue.rsLong) ?? 0.0)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue.rsPubName
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let alert = UIAlertController(title: "Attention", message: "Your venue is nearby \(venue.rsPubName!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("entering")
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Thanks!", message: "Thank you for calling by \(region.identifier), See you again soon", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("exiting")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "venueEvents" {
            let vc = segue.destination as! venueeventsViewController
            vc.venueid = venue.key!
        }
    }
    
    
    
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

