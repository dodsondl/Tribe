//
//  localEventsCell.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/1/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase

class localEventsCell: UICollectionViewCell {
    
    @IBOutlet weak var localEventsImage: UIImageView!
    @IBOutlet weak var localEventsName: UILabel!
    @IBOutlet weak var localEventsDate: UILabel!
    
    var eventPost: eventPostInfo!
    var eventPostKey: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
    func configCell(eventPost: eventPostInfo) {
        self.eventPost = eventPost
        self.localEventsDate.text = eventPost.eventdate
        self.localEventsName.text = eventPost.eventname
       
        self.localEventsImage.image = UIImage(named: "\(eventPost.eventType)")
        
    }
    
    
}
