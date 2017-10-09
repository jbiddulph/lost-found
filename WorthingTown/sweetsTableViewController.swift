//
//  sweetsTableViewController.swift
//  thisworthing
//
//  Created by John Biddulph on 06/02/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class sweetsTableViewController: UITableViewController {

    var dbRef:DatabaseReference!
    var addedBy = String()
    var sweets = [Sweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = Database.database().reference().child("sweet-items")
        startObservingDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (Auth, User) in
            if let user = User {
                print("Welcome \(user.email)")
                self.addedBy = user.email!
                self.startObservingDB()
            } else {
                print("You need to sign up or login first")
            }
        }
        
        
    }
    
    func startObservingDB(){
        
        dbRef.observe(DataEventType.value, with: { (snapshot:DataSnapshot) in
            var newSweets = [Sweet]()
            
            
            for sweet in snapshot.children.allObjects{
                let sweetObject = Sweet(snapshot: sweet as! DataSnapshot)
                newSweets.append(sweetObject)
            }
            
            self.sweets = newSweets
            self.tableView.reloadData()
        })
        
    }
    
    
    @IBAction func addSweet(_ sender: Any) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your sweet name", preferredStyle: .alert)
        sweetAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Your Sweet"
        })
        
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler:{ (action:UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text {
                
                let sweet = Sweet(content: sweetContent, addedByUser: self.addedBy)
                let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.toAnyObject())
            }
        }))
        self.present(sweetAlert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let sweet = sweets[indexPath.row]
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.addedByUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sweet = sweets[indexPath.row]
            sweet.itemRef?.removeValue()
        }
    }
        
    

}
