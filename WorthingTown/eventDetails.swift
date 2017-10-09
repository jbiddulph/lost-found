//
//  eventDetails.swift
//  WorthingTown
//
//  Created by John Biddulph on 02/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


class eventDetails: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    var user: User?
    var ref:DatabaseReference!
    var refHandle: UInt!
    var databaseHandle: DatabaseHandle!
    var event :Event!
    var name: String!
    let manager = CLLocationManager()
    var theeventId = String()
    var itemId = String()
    var filteredBy = String()
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var theEvent: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventTime: UILabel!
    
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventImage1: UIImageView!
    @IBOutlet var claimIt: UIButton!
    @IBOutlet var labelMessage: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let latName = Double(event.rsLat) ?? 0.0
        let lonName = Double(event.rsLon) ?? 0.0
        //let londonLat = self.manager.location?.coordinate.latitude
        //let londonLon = self.manager.location?.coordinate.longitude
        //let londonLat = 50.81787
        //let londonLon = -0.37288200000000415
        let distancespan:CLLocationDegrees = 5000
        let worthingLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latName, lonName)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(worthingLocation, distancespan, distancespan), animated: true)
        mapView.clipsToBounds = true
        let worthingClassPin = mapAnnotation(title: "My Location", subtitle: "Here I am!", coordinate: worthingLocation, pinTintColor: UIColor.brown, imageName: "marker.png")
        
        //let worthingClassPin = mapAnnotation(title: "My Location", subtitle: "Here I am!", coordinate: worthingLocation)
        
        mapView.addAnnotation(worthingClassPin)
        
        self.theEvent.text = event.rsEvent
        self.eventDate.text = event.rsEventDate
        self.eventTime.text = event.rsEventTime
        
        let theImageURL = event.rsEventImage
        
        
        
//        let latitude = Double(latName!) ?? 0.0
//        let longitude = Double(lonName!) ?? 0.0
        
        let theTitle = event.rsEvent
        let subTitle = event.rsEventDate
        let thepostCode = event.rsEventTime
        
        if(self.theEvent.text != ""){
            self.theEvent.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        if(self.eventDate.text != ""){
            self.eventDate.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        if(self.eventTime.text != ""){
            self.eventTime.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        self.theEvent.textColor = UIColor.white
        self.eventDate.textColor = UIColor.white
        self.eventTime.textColor = UIColor.white
//        let distancespan1:CLLocationDegrees = 5000
//        let theLocations:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(theLocations, distancespan1, distancespan), animated: true)
        
        //let worthingClassPin1 = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations)
        //let worthingClassPin1 = mapAnnotation(title: theTitle!, subtitle: subTitle!, coordinate: theLocations, pinTintColor: UIColor.purple)
        //self.mapView.addAnnotation(worthingClassPin1)
        eventImage.downloadedFrom(link: theImageURL!)
        eventImage1.downloadedFrom(link: theImageURL!)
        //venueImage1.layer.cornerRadius = venueImage1.frame.size.height/2
        
        //venueImage1.clipsToBounds = true
    }
    
    @IBAction func claimItNow(_ sender: Any) {
        showInputDialog()
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter details?", message: "Enter your name and email", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            self.name = alertController.textFields?[0].text
            
            self.labelMessage.text = "Name: " + self.name!
            self.handleSend()
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Message"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let itemRef = Database.database().reference().child("item-messages")
        let childItemRef = itemRef.childByAutoId()
        let toId = event.addedBy
        let fromId = Auth.auth().currentUser!.uid
        
        let theItemref = Database.database().reference().child("item-messages").child(event.key)
        theItemref.observe(.childAdded, with: { (snapshot) in
            self.itemId = snapshot.key
        })
        let theEventref = Database.database().reference().child("worthing-events-list").child(event.key)
        theEventref.observe(.childAdded, with: { (snapshot) in
            self.theeventId = snapshot.key
        })
        filteredBy = self.itemId+"_"+self.theeventId
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text":self.name!, "toId": toId, "fromId": fromId, "timestamp": timeStamp, "theFilter": filteredBy] as [String : Any]
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("item-messages").child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            
            //let recipientUserMessagesRef = FIRDatabase.database().reference().child("item-messages").child("user-messages").child(toId)
            //let recipientUserMessagesRef = Database.database().reference().child("item-messages").child("44CB77A8-0DAB-4F12-8DC5-DDD5DDD6D500")
            let recipientUserMessagesRef = Database.database().reference().child("item-messages").child(self.event.key)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatController" {
            let vc = segue.destination as! myChatLogController
            vc.event = self.event
        }
    }

    
    
}

