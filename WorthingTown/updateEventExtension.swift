//
//  updateEventextension.swift
//  WorthingTown
//
//  Created by John Biddulph on 02/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UpdateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func updateVenue(){
        
        guard let eventName = theEventname.text, let eventDate = theEventdate.text, let eventTime = theEventtime.text, let eventImage = theEventimage.text, let eventPrice = theEventprice.text, let eventCategory = theEventCategory.text, let eventStatus = theEventstatus.text, let eventVenue = theEventvenue.text, let eventLat = theEventLat.text, let eventLon = theEventLon.text, let eventApproval = String("_N"), let addedBy = theAddedBy.text else{
            print("Form is not valid")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        if let eventTitle = theEventname.text {
            let imageNamed = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("event_images").child("\(imageNamed).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        //let theLat = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
                        //let theLon = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
                        
                        let event = Event(rsEvent: eventName, rsEventVenue: eventVenue, rsEventDate: eventDate, rsEventTime: eventTime, rsEventCategory: eventCategory, rsEventPrice: eventPrice, rsEventStatus: eventStatus, rsEventImage: eventImage, rsLat: eventLat, rsLon: eventLon, rsApproved: eventStatus+eventApproval, addedBy: addedBy)
                        
                        
                        //let event = Event(rsEvent: eventName, rsEventVenue: eventVenue, rsEventDate: eventDate, rsEventTime: eventTime, rsEventCategory: eventCategory, rsEventPrice: eventPrice, rsEventTickets: eventTickets, rsEventImage: eventImage)
                        
                        
                        //let random = NSUUID().uuidString
                        
                        //let venueRef = self.dbRef.child(random)
                        
                        //venueRef.setValue(venue.toAnyObject())
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
            
        }
        
        
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}

