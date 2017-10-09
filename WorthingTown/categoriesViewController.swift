//
//  categoriesViewController.swift
//  thisworthing
//
//  Created by John Biddulph on 08/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class categoriesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var event :Eventvenue!
    @IBOutlet var bigLabel: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    var dbRef:DatabaseReference!
    var venues = [Venue]()
    var food = ["hello","world","this is john"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        dbRef = Database.database().reference().child("venue-list").child("worthing-venue-list")
        pickerSelector()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerSelector(){
        
        dbRef.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newVenues = [Venue]()
            
            
            for venue in snapshot.children.allObjects{
                let venueObject = Venue(snapshot: venue as! DataSnapshot)
                newVenues.append(venueObject)
            }
            self.picker.delegate = self
            self.picker.dataSource = self
            
            self.venues = newVenues
        })
        
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // return sweets[row]
        
    }*/
    // The number of rows of data
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return venues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bigLabel.text = venues[row].rsPubName
        label.text = venues[row].key
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return venues[row].rsPubName
    }
    
    @IBAction func updatetheEvent(_ sender: Any) {
        //updateVenue()
        let updatedEvent = Eventvenue(rsEventVenue: label.text!)
        
        let key = event.itemRef!.key
        let updateRef = Database().reference().child("events-list").child("/worthing-events-list/\(key)")
        updateRef.updateChildValues(updatedEvent.toAnyObject())
    }
    

}
