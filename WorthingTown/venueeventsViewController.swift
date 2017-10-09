//
//  venueeventsViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 26/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

//
//  eventsViewController.swift
//  WorthingTown
//
//  Created by John Biddulph on 02/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class venueeventsViewController: UITableViewController {
    
    var dbRef:DatabaseReference?
    var admin = 0
    var events = [Event]()
    var venueid = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkIfUserIsLoggedIn()
        tableView.register(venueEventCell.self, forCellReuseIdentifier: "venueeventcell")
        
        
        //fetchEvent()
        dbRef = Database.database().reference().child("events-list").child("worthing-events-list")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let user = User {
                print("Welcome \(user.email)")
                if user.email == "john@john.com" {
                    self.admin = 1
                }
                print("This is the venueID: \(self.venueid)")
                self.fetchEvent()
            } else {
                print("You need to sign up or login first")
            }
        }        
    }
    
    func fetchEvent(){
        
        let query = dbRef!.queryOrdered(byChild: "rsEventVenue").queryEqual(toValue: venueid)
        query.observe(.value, with: { (snapshot) in
        //dbRef.observe(FIRDataEventType.value, with: { (snapshot:FIRDataSnapshot) in
            var newEvents = [Event]()
            
            
            for event in snapshot.children.allObjects{
                let eventObject = Event(snapshot: event as! DataSnapshot)
                
                newEvents.append(eventObject)
            }
            
            
            self.events = newEvents
            
            self.tableView.reloadData()
        })
        
    }
    
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueeventcell", for: indexPath) as! venueEventCell
        
        let event = events[indexPath.row]
        cell.textLabel?.text = event.rsEvent
        cell.detailTextLabel?.text = event.rsEventDate
        let theImageURL = event.rsEventImage
        
        cell.eventsImageView.loadImageUsingCacheWithUrlString(theImageURL!)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.admin == 0 {
            performSegue(withIdentifier: "eventDetails", sender: self)
        } else if self.admin == 1 {
            performSegue(withIdentifier: "updateevent", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetails" {
            let vc = segue.destination as! eventDetails
            let indexPath = tableView.indexPathForSelectedRow
            vc.event = events[(indexPath?.row)!]
        } else if segue.identifier == "updateevent" {
            let vc = segue.destination as! UpdateEventViewController
            let indexPath = tableView.indexPathForSelectedRow
            vc.event = events[(indexPath?.row)!]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.admin == 0 {
            let alert = UIAlertController(title: "Alert", message: "Sorry, you do not have administrator rights", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if editingStyle == .delete {
                let event = events[indexPath.row]
                event.itemRef?.removeValue()
            }
        }
    }
    
    
}

class venueEventCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let eventsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(eventsImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height
        eventsImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        eventsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        eventsImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        eventsImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
