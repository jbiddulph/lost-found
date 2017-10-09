//
//  UpdateVenueViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 30/03/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class UpdateVenueViewController: UIViewController, CLLocationManagerDelegate {
    
    var dbRef:DatabaseReference!
    var addedBy = String()
    
    var venue :Venue!
    let manager = CLLocationManager()
    @IBOutlet var theVenuename: UITextField!
    @IBOutlet var theVenuephone: UITextField!
    @IBOutlet var theVenuepostcode: UITextField!
    @IBOutlet var theVenueAddress: UITextField!
    @IBOutlet var theVenueAddress2: UITextField!
    @IBOutlet var theVenueAddress3: UITextField!
    @IBOutlet var theVenueTown: UITextField!
    @IBOutlet var theVenueRegion: UITextField!
    @IBOutlet var theVenueWebsite: UITextField!
    @IBOutlet var Lat: UITextField!
    @IBOutlet var Long: UITextField!
    @IBOutlet var getLocation: UIButton!
    
    
    lazy var profileImageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage(named: "clickupload")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        self.hideKeyboardWhenTappedAround() 
        setupProfileImageView()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        theVenuename.text = venue.rsPubName
        theVenuephone.text = venue.rsTel
        theVenueAddress.text = venue.rsAddress
        theVenueAddress2.text = venue.rsAdd2
        theVenueAddress3.text = venue.rsAdd3
        theVenueTown.text = venue.rsTown
        theVenuepostcode.text = venue.rsPostCode
        theVenueRegion.text = venue.rsRegion
        theVenueWebsite.text = venue.rsWebsite
        Lat.text = venue.rsLat
        Long.text = venue.rsLong
        
        // Do any additional setup after loading the view.
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: theVenuename.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    @IBAction func updatetheVenue(_ sender: Any) {
        //updateVenue()
        let updatedVenue = Venue(rsPubName: theVenuename.text!, rsLat: Lat.text!, rsLong: Long.text!, rsPostCode: theVenuepostcode.text!, rsTel: theVenuephone.text!, rsTown: theVenueTown.text!, rsImageURL: venue.rsImageURL, rsAddress: theVenueAddress.text!, rsAdd2: theVenueAddress2.text!, rsAdd3: theVenueAddress3.text!, rsRegion: theVenueRegion.text!, rsWebsite: theVenueWebsite.text!)
        
        let key = venue.itemRef?.key
        //let updateRef = FIRDatabase.database().reference().child("venue-list").child("worthing-venue-list/\(key)/")
        let updateRef = Database.database().reference().child("venue-list").child("/worthing-venue-list/\(key)")
        updateRef.updateChildValues(updatedVenue.toAnyObject())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        Lat.text = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
        Long.text = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
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
