//
//  NewVenueViewController.swift
//  thisworthing
//
//  Created by John Biddulph on 08/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class NewVenueViewController: UIViewController, CLLocationManagerDelegate {

    var dbRef:DatabaseReference!
    var addedBy = String()
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
        setupProfileImageView()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.hideKeyboardWhenTappedAround() 
        dbRef = Database.database().reference().child("events-list").child("worthing-events-list")
        // Do any additional setup after loading the view.
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: theVenuename.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    @IBAction func addVenue(_ sender: Any) {
        createnewVenue()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
