//
//  myChatLogController.swift
//  LostFound
//
//  Created by John Biddulph on 28/06/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//
import FirebaseDatabase
import FirebaseAuth
import Foundation
import UIKit
import Firebase

class myChatLogController: UITableViewController {
    
    let cellId = "cellId"
    var event :Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //performSegue(withIdentifier: "chatLogController", sender: self)
        navigationItem.title = "My Messages"
        
        //checkIfUserIsLoggedIn()
        //observeMessage()
        observeUserMessage()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessage(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let itemref = Database.database().reference().child("item-messages").child(event.key)
        
        itemref.observe(.childAdded, with: { (snapshot) in
            let itemId = snapshot.key
            print(itemId)

            let messagesRef = Database.database().reference().child("messages").child(itemId)
            
            messagesRef.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    print(message.text)
                    self.messages.append(message)
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
            
//            let ref = FIRDatabase.database().reference().child("item-messages").child(itemId).child("user-messages").child(uid)
//            ref.observe(.childAdded, with: { (snapshot) in
//                let messageId = snapshot.key
//                let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
//                messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
//                    //print(snapshot)
//                    if let dictionary = snapshot.value as? [String: AnyObject] {
//                        let message = Message(dictionary: dictionary)
//                        
//                        
//                        if let chatPartnerId = message.chatPartnerId(){
//                            self.messagesDictionary[chatPartnerId] = message
//                            
//                            self.messages = Array(self.messagesDictionary.values)
//                            self.messages.sorted(by: { (message1, message2) -> Bool in
//                                return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
//                            })
//                        }
//                        self.timer?.invalidate()
//                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//                        
//                        
//                    }
//                }, withCancel: nil)
//                
//            }, withCancel: nil)
        
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    func handleReloadTable(){
        DispatchQueue.main.async(execute: {
            print("we reloaded the table")
            self.tableView.reloadData()
        })
    }
    
    
    
    func observeMessage(){
        let itemref = Database.database().reference().child("item-messages").child(event.key)
        itemref.observe(.childAdded, with: { (snapshot) in
            let itemId = snapshot.key
            print(itemId)
            let ref = Database.database().reference().child("messages").child(itemId)
            
            ref.observe(.childAdded, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    
                    
                    if let toId = message.toId{
                        self.messagesDictionary[message.toId!] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sorted(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    //this will crash because of background thread, so lets call this on dispatch_async main thread
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String: AnyObject]
            else {
                return
            }
            let user = User(dictionary: [:])
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
                self.showChatControllerForUser(user: user)
        }, withCancel: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
                let theImageURL = user.profileImageUrl
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chatLogController" {
            let vc = segue.destination as! ChatLogController
            vc.event = self.event
        }
    }
}
