//
//  eventsCollectionViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 09/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class eventsCollectionViewController: UICollectionViewController {

    var dbRef:DatabaseReference!
    var admin = 0
    var events = [Event]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkIfUserIsLoggedIn()
        
        dbRef = Database.database().reference().child("events-list").child("worthing-events-list")
        fetchEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let user = User {
                print("Welcome \(user.email)")
                if user.email == "john@john.com" {
                    self.admin = 1
                }
                self.fetchEvent()
            } else {
                print("You need to sign up or login first")
            }
        }
    }
    
    func fetchEvent(){
        
        dbRef.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newEvents = [Event]()
            
            
            for event in snapshot.children.allObjects{
                let eventObject = Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            
            self.events = newEvents
            self.collectionView?.reloadData()
        })
        
    }
    
    
    func handleNewMessage() {
        let newMessageController = usersViewController()
        //newMessageController.messagesController? = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventcell", for: indexPath) as! UICollectionViewCell
        
        let event = events[indexPath.row]
        //eventTitle.text = event.rsEvent
        //eventDate.text = event.rsEventDate
        //cell.textLabel?.text = event.rsEvent
        //cell.detailTextLabel?.text = event.rsEventDate
        let theImageURL = event.rsEventImage
        
    //EVENT IMAGE
        //cell.eventsImageView.loadImageUsingCacheWithUrlString(theImageURL!)
        //        let url = NSURL(string: theImageURL!)
        //        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
        //            if error != nil {
        //                print(error)
        //                return
        //            }
        //            if data != nil {
        //                DispatchQueue.main.async {
        //                    cell.placesImageView.image = UIImage(data: data!)
        //                }
        //            }
        //
        //        }.resume()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.admin == 0 {
            performSegue(withIdentifier: "eventDetails", sender: self)
        } else if self.admin == 1 {
            performSegue(withIdentifier: "updateevent", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetails" {
            let vc = segue.destination as! eventDetails
            let indexPath = collectionView?.indexPathsForSelectedItems
            //vc.event = events[(indexPath?.row)!]
        } else if segue.identifier == "updateevent" {
            let vc = segue.destination as! UpdateEventViewController
            let indexPath = collectionView?.indexPathsForSelectedItems
            //vc.event = events[(indexPath?.row)!]
        }
    }
    
    
    
}

