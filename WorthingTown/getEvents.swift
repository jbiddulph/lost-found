//
//  getEvents.swift
//  Pods
//
//  Created by John Biddulph on 10/04/2017.
//
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth


class getEvents: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var dbRef:DatabaseReference!
    var admin = 0
    var events = [Event]()
    var thelocationName = String()
    var foundlostHeader = String()
    var foundlostApproved = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.title = foundlostHeader
        if(foundlostHeader == "Lost"){
            navigationController?.navigationBar.barTintColor = UIColor.red
        } else if(foundlostHeader == "Found"){
            navigationController?.navigationBar.barTintColor = UIColor.green
        } else {
            navigationController?.navigationBar.barTintColor = UIColor.blue
        }
        fetchEvent()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView?.register(eventsCollectionViewCell.self, forCellWithReuseIdentifier: "eventCell")
        //collectionView?.backgroundColor = UIColor.green
        view.addSubview(collectionView!)
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
        foundlostApproved = thelocationName+"_"+foundlostHeader+"_Y"
        //foundlostApproved = "Worthing"+"_"+foundlostHeader+"_Y"
        print(foundlostApproved)
        print("FoundLost header: \(foundlostHeader)")
        dbRef = Database.database().reference().child("events-list").child("worthing-events-list")
        //var query = dbRef.queryOrdered(byChild: "rsApproved").queryEqual(toValue: foundlostApproved)
        //var query = dbRef.queryOrdered(byChild: "rsEventStatus").queryEqual(toValue: foundlostHeader)
        var query = dbRef.queryOrdered(byChild: "rsApproved").queryEqual(toValue: foundlostApproved)
        
        query.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newEvents = [Event]()
            
            
            for event in snapshot.children.allObjects{
                let eventObject = Event(snapshot: event as! DataSnapshot)
                newEvents.append(eventObject)
            }
            
            self.events = newEvents
            self.collectionView?.reloadData()
        })
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! eventsCollectionViewCell
        
        cell.awakeFromNib()
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let eventCell = cell as! eventsCollectionViewCell
        let event = events[indexPath.row]
        let theImageURL = event.rsEventImage
        eventCell.eventImageView.loadImageUsingCacheWithUrlString(theImageURL!)
        eventCell.eventTitle.text = event.rsEvent
        eventCell.eventDate.text = event.rsEventDate
        eventCell.eventStatus = event.rsEventStatus
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2, height: 200)
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
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                vc.event = events[indexPath.row]
            }
        } else if segue.identifier == "updateevent" {
            let vc = segue.destination as! UpdateEventViewController
            let indexPath = collectionView?.indexPathsForSelectedItems
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                vc.event = events[indexPath.row]
            }
        }
    }
    
}
