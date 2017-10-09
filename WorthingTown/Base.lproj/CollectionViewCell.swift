//
//  CollectionViewCell.swift
//  WorthingTown
//
//  Created by John Biddulph on 09/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class CollectionViewCell: UICollectionViewCell {
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
