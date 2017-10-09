//
//  placesViewController.swift
//  thisworthing
//
//  Created by John Biddulph on 19/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import MapKit

class placesViewController: UITableViewController, CLLocationManagerDelegate {
    
    var dbRef:DatabaseReference!
    var admin = 0
    var places = [Venue]()
    //var locationManager: CLLocation?
    var locationManager: CLLocationManager?
    let distanceFormatter = MKDistanceFormatter()
    let theLocations: CLLocation! = nil
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.coordinate.latitude)
        print(manager.location?.coordinate.longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkIfUserIsLoggedIn()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        tableView.register(PlaceCell.self, forCellReuseIdentifier: "placecell")
        dbRef = Database.database().reference().child("lost-found").child("locations-list")
        fetchVenue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let user = User {
                print("Welcome \(user.email)")
                if user.email == "john@john.com" {
                    self.admin = 1
                }
                self.fetchVenue()
            } else {
                print("You need to sign up or login first")
            }
        }
        
    }
    
    func fetchVenue(){
        
        //dbRef.observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt
        //dbRef.observe(DataEventType, with: { (snapshot:DataSnapshot) in
          //  var newPlaces = [Venue]()
            
            
            //for venue in snapshot.children.allObjects{
            //    let venueObject = Venue(snapshot: venue as! FIRDataSnapshot)
            //    newPlaces.append(venueObject)
           // }
            
            //self.places = newPlaces
            //self.tableView.reloadData()
        //})
   }
        
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placecell", for: indexPath) as! PlaceCell
        
        let place = places[indexPath.row]
        
        let latName = place.rsLat as? String
        let lonName = place.rsLong as? String
        let latitude = Double(latName!) ?? 0.0
        let longitude = Double(lonName!) ?? 0.0
        let mylat = locationManager?.location?.coordinate.latitude
        let mylon = locationManager?.location?.coordinate.longitude

        let theLocations:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var one = CLLocation(latitude: mylat!, longitude: mylon!)
        var two = CLLocation(latitude: latitude, longitude: longitude)
        let distance = two.distance(from: one)/1609.344
        

        cell.textLabel?.text = place.rsPubName
        cell.detailTextLabel?.text = (NSString(format:"%.2f", distance) as String)
        
        let theImageURL = place.rsImageURL
        
        cell.placesImageView.loadImageUsingCacheWithUrlString(theImageURL!)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.admin == 0 {
            performSegue(withIdentifier: "moreDetails", sender: self)
        } else if self.admin == 1 {
            performSegue(withIdentifier: "updatevenue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreDetails" {
            let vc = segue.destination as! venueDetails
            let indexPath = tableView.indexPathForSelectedRow
            vc.venue = places[(indexPath?.row)!]
        } else if segue.identifier == "updatevenue" {
            let vc = segue.destination as! UpdateVenueViewController
            let indexPath = tableView.indexPathForSelectedRow
            vc.venue = places[(indexPath?.row)!]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.admin == 0 {
            let alert = UIAlertController(title: "Alert", message: "Sorry, you do not have administrator rights", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if editingStyle == .delete {
                let place = places[indexPath.row]
                place.itemRef?.removeValue()
            }
        }
    }
    

}

class PlaceCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

    }
    
    let placesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(placesImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height
        placesImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        placesImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        placesImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        placesImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
