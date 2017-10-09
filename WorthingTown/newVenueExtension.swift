//
//  newVenueExtension.swift
//  thisworthing
//
//  Created by John Biddulph on 20/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension NewVenueViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func createnewVenue(){
        
        guard let venuePhone = theVenuephone.text, let venuePostCode = theVenuepostcode.text, let venueRegion = theVenueRegion.text, let venueTown = theVenueTown.text, let venueName = theVenuename.text, let venueAddress = theVenueAddress.text, let theVenueAdd2 = theVenueAddress2.text, let theVenueAdd3 = theVenueAddress3.text, let VenueRegion = theVenueRegion.text, let theVenueWebsite = theVenueWebsite.text else{
            print("Form is not valid")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
        
        if let venueName = theVenuename.text {
            let imageNamed = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("venue_images").child("\(imageNamed).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let theLat = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
                        let theLon = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
                        
                        
                        let venue = Venue(rsPubName: venueName, rsLat: theLat, rsLong: theLon, rsPostCode: venuePostCode, rsTel: venuePhone, rsTown: venueTown, rsImageURL: profileImageURL, rsAddress: venueAddress, rsAdd2: theVenueAdd2, rsAdd3: theVenueAdd3, rsRegion: venueRegion, rsWebsite: theVenueWebsite)
                        
                        //let venue = Venue(rsPubName: venueName, rsLat: theLat, rsLong: theLon, rsPostCode: venuePostCode, rsTel: venu, rsTown: self.addedBy, rsImageURL:profileImageURL  )
                        
                        let random = NSUUID().uuidString
                        
                        let venueRef = self.dbRef.child(random)
                        
                        venueRef.setValue(venue.toAnyObject())
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

