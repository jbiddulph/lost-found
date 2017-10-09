//
//  eventsCollectionViewCell.swift
//  WorthingTown
//
//  Created by John Biddulph on 10/04/2017.
//  Copyright © 2017 John Biddulph. All rights reserved.
//

import UIKit

class eventsCollectionViewCell: UICollectionViewCell {
    
    var eventImageView: UIImageView!
    var eventTitle: UILabel!
    var eventDate: UILabel!
    var eventStatus = String()
    
    var foundlostHeader = String()
    
    override func awakeFromNib() {
        eventImageView = UIImageView(frame: contentView.frame)
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventTitle = UILabel()
        eventDate = UILabel()
        //eventStatus = UILabel()
        eventTitle.frame = CGRect(x: 0, y: frame.height-190, width: frame.width, height: 30)
        eventTitle.textColor = UIColor(r: 255, g: 255, b: 255)
        eventTitle.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        eventTitle.textAlignment = .center
        eventTitle.font = eventTitle.font.withSize(12)
        eventDate.frame = CGRect(x: 0, y: frame.height-40, width: frame.width, height: 30)
        eventDate.textColor = UIColor(r: 255, g: 255, b: 255)
        
        if(eventStatus == "Found"){
            eventTitle.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            eventDate.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        } else if(eventStatus == "Lost"){
            eventTitle.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            eventDate.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        eventDate.textAlignment = .center
        eventDate.font = eventDate.font.withSize(8)
        //eventTitle.frame = CGRect(x: 64, y: eventTitle!.frame.origin.y - 2, width: eventTitle!.frame.width, height: eventTitle.frame.height)
        contentView.addSubview(eventImageView) //remember to add UI elements to the content view, not the view itself
        contentView.addSubview(eventTitle)
        contentView.addSubview(eventDate)
    }
    
}
