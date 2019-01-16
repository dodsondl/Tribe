//
//  messageVCTV.swift
//  Tribe
//
//  Created by Daniel Dodson on 12/5/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class messageVCTV: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventPosts = [eventPostInfo]()
    var tribePosts = [messageTribePost]()
    var eventPost: eventPostInfo!
    var tribePost: messageTribePost!
    var tribeData = [String].self
    
    
  
    let userID = Auth.auth().currentUser?.uid

    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        Database.database().reference().child("users").child("\(userID!)").child("tribes").observe(.value, with:
            {(snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                  self.tribePosts.removeAll()
                    for data in snapshot {
                        print(data)
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                           let key = data.key
                           let tribePost = messageTribePost(tribePostKey: key, tribePostData: postDict)
                           self.tribePosts.append(tribePost)
                            print(self.tribePosts.count)
                            
                            
                        }
                    }
                }
                self.messageTableView.reloadData()
        
        })
        
        /*
        Database.database().reference().child("tribes").observe(.value, with:
            {(snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.tribePosts.removeAll()
                    for data in snapshot {
                        print(data)
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                            let key = data.key
                            let tribePost = tribePostInfo(tribePostKey: key, tribePostData: postDict)
                            self.tribePosts.append(tribePost)
                            print(self.tribePosts.count)
                            
                            
                        }
                    }
                }
                self.messageTableView.reloadData()
        })
*/
       
        
      
    }
    override func viewDidAppear(_ animated: Bool) {
        messageTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventPosts.count)
        return tribePosts.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tribePost = tribePosts[indexPath.row]
        print(tribePosts.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageDetailCell", for: indexPath) as? messageDetailCell
        cell?.configCell(tribePost: tribePost)
        return cell!
    }
    


}
