//
//  newEventExtension.swift
//  WorthingTown
//
//  Created by John Biddulph on 01/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension NewEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func createnewEvent(){
        
        guard let theeventName = eventName.text, let theeventVenue = eventVenue.text, let theeventDate = eventDate.text, let theeventTime = eventTime.text, let theeventCategory = eventCategory.text, let theeventPrice = eventPrice.text, let theeventStatus = eventStatus.text else{
            print("Form is not valid")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if let eventName = eventName.text {
            let imageNamed = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("event_images").child("\(imageNamed).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, eror) in
                    if eror != nil {
                        print(eror)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let theLat = String(describing: self.mapLatitude)
                        let theLon = String(describing: self.mapLonitude)
                        let theApproval = theeventPrice+("_")+theeventStatus+String("_N")
                        let theeventPrice = self.thelocationName
                        let theAddedBy = Auth.auth().currentUser?.uid
                        //let theLat = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
                        //let theLon = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
                        
                        let event = Event(rsEvent: eventName, rsEventVenue: theeventVenue, rsEventDate: theeventDate, rsEventTime: theeventTime, rsEventCategory: theeventCategory, rsEventPrice: theeventPrice, rsEventStatus: theeventStatus, rsEventImage: profileImageURL, rsLat: theLat, rsLon: theLon, rsApproved: theApproval, addedBy: theAddedBy!)
                        
                        let random = NSUUID().uuidString
                        
                        let eventRef = self.dbRef.child(random)
                        
                        eventRef.setValue(event.toAnyObject())
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
            
        }
        
    }
    
    func addLocation() {
        let ref = Database.database().reference().child("towns")
        let childRef = ref.childByAutoId()
        let values = ["townName":eventPrice.text!]
        childRef.updateChildValues(values)
    }
    func addItemChat() {
        let ref = Database.database().reference().child("events-list").child("worthing-events-list")
        let childRef = ref.childByAutoId()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let toId = uid
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let itemref = Database.database().reference().child("events-list").child("worthing-events-list")
        itemref.observe(.childAdded, with: { (snapshot) in
            let itemId = snapshot.key
            let userMessagesRef = Database.database().reference().child("item-messages").child(itemId).child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("item-messages").child(itemId).child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
         }, withCancel: nil)
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

