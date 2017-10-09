//
//  UpdateEventViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 02/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class UpdateEventViewController: UIViewController, CLLocationManagerDelegate {
    
    var dbRef:DatabaseReference!
    var addedBy = String()
    
    var event :Event!
    let manager = CLLocationManager()
    @IBOutlet var theEventname: UITextField!
    @IBOutlet var theEventdate: UITextField!
    @IBOutlet var theEventtime: UITextField!
    @IBOutlet var theEventCategory: UITextField!
    @IBOutlet var theEventimage: UITextField!
    @IBOutlet var theEventstatus: UITextField!
    @IBOutlet var theEventprice: UITextField!
    @IBOutlet var theEventvenue: UITextField!
    @IBOutlet var theEventLat: UITextField!
    @IBOutlet var theEventLon: UITextField!
    @IBOutlet var getLocation: UIButton!
    @IBOutlet var theAddedBy: UITextField!
    
    
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
        theEventname.text = event.rsEvent
        theEventvenue.text = event.rsEventVenue
        theEventstatus.text = event.rsEventStatus
        theEventCategory.text = event.rsEventCategory
        theEventprice.text = event.rsEventPrice
        theEventimage.text = event.rsEventImage
        theEventtime.text = event.rsEventTime
        theEventdate.text = event.rsEventDate
        theEventLat.text = event.rsLat
        theEventLon.text = event.rsLon
        theAddedBy.text = event.addedBy
        // Do any additional setup after loading the view.
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: theEventname.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    @IBAction func updatetheEvent(_ sender: Any) {
        //updateVenue()
        let updatedEvent = Event(rsEvent: theEventname.text!, rsEventVenue: theEventvenue.text!, rsEventDate: theEventdate.text!, rsEventTime: theEventtime.text!, rsEventCategory: theEventCategory.text!, rsEventPrice: theEventprice.text!, rsEventStatus: theEventstatus.text!, rsEventImage: theEventimage.text!, rsLat: theEventLat.text!, rsLon: theEventLon.text!, rsApproved: String("N")!, addedBy: theAddedBy.text!)
        
        let key = event.itemRef!.key
        //let updateRef = FIRDatabase.database().reference().child("venue-list").child("worthing-venue-list/\(key)/")
        let updateRef = Database.database().reference().child("events-list").child("/worthing-events-list/\(key)")
        updateRef.updateChildValues(updatedEvent.toAnyObject())
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func getLocation(_ sender: UIButton) {
        theEventLat.text = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
        theEventLon.text = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
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
