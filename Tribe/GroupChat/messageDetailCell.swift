//
//  messageDetailCell.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/22/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class messageDetailCell: UITableViewCell {

    @IBOutlet weak var messageTribeName: UILabel!
    @IBOutlet weak var messagePreview: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    @IBOutlet weak var messageImageView: UIImageView!
    
    var userPostKey: DatabaseReference!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    let userID = Auth.auth().currentUser?.uid
    
    var tribePost: messageTribePost!
    var tribePostKey: DatabaseReference!
    
   // var messageDetails = messageDetail()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func configCell(tribePost: messageTribePost){
         self.tribePost = tribePost
        self.messageTribeName.text = tribePost.tribeName
        self.messageTime.text = "2 Min"
        self.messageImageView.image = UIImage(named: "\(tribePost.tribeType)")
        
    }


}
