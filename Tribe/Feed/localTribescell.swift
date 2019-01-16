//
//  localTribescell.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/1/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase

class localTribescell: UICollectionViewCell {
    
    @IBOutlet weak var tribeImageView: UIImageView!
    @IBOutlet weak var tribeName: UILabel!
    @IBOutlet weak var tribeMemberNumber: UILabel!
    
    var tribePost: tribePostInfo!
    var tribePostKey: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func configCell(tribePost: tribePostInfo) {
        self.tribePost = tribePost
        self.tribeName.text = tribePost.tribeName
        self.tribeMemberNumber.text = "23 Members"
        self.tribeImageView.image = UIImage(named: "\(tribePost.tribeType)")
        
    }
}
