//
//  profileVC.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/1/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit

class profileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func logOut(_ sender: Any) {
        User.logOutUser { (status) in
            if status == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
