//
//  launchVC.swift
//  Tribe
//
//  Created by Daniel Dodson on 1/9/19.
//  Copyright © 2019 Daniel Dodson. All rights reserved.
//

import UIKit

class launchVC: UIViewController {

    //MARK: Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .feed:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC") as! UITabBarController
            self.present(vc, animated: false, completion: nil)
        case .firstViewController:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .feed)
                    } else {
                        weakSelf?.pushTo(viewController: .firstViewController)
                    }
                    weakSelf = nil
                }
            })
        } else {
            self.pushTo(viewController: .firstViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 

}
