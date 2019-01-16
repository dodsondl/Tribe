//
//  FirstViewController.swift
//  Tribe
//
//  Created by Daniel Dodson on 9/11/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Photos

class FirstViewController: UIViewController, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var clouds: UIImageView!
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet var registerView: UIView!
   let imagePicker = UIImagePickerController()
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet var profilePic: UIImageView!
    var loginViewTopConstraint: NSLayoutConstraint!
    var registerTopConstraint: NSLayoutConstraint!
    var isLoginViewVisible = true
    
    @IBOutlet var warningLabel: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // signUpButton.layer.cornerRadius = 25
        self.customization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
      self.initalWarning()
       // if var _ = KeychainWrapper.standard.string(forKey: "userid6") {
        //    goToFeedVC()
        //}
    }
    
    func customization()  {
      self.darkView.alpha = 0
        self.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
        self.profilePic.layer.borderWidth = 2
        
        //LoginView customization
        self.view.insertSubview(self.loginView, belowSubview: self.clouds)
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        self.loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginViewTopConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.loginViewTopConstraint.isActive = true
        self.loginView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        self.loginView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.loginView.layer.cornerRadius = 8
        //RegisterView Customization
        self.view.insertSubview(self.registerView, belowSubview: self.clouds)
        self.registerView.translatesAutoresizingMaskIntoConstraints = false
        self.registerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.registerTopConstraint = NSLayoutConstraint.init(item: self.registerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.registerTopConstraint.isActive = true
        self.registerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        self.registerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.registerView.layer.cornerRadius = 8
     
    }
    

    @IBAction func switchViews(_ sender: UIButton) {
        if self.isLoginViewVisible {
            self.isLoginViewVisible = false
            sender.setTitle("Login", for: .normal)
            self.loginViewTopConstraint.constant = 1000
            self.registerTopConstraint.constant = 60
        } else {
            self.isLoginViewVisible = true
            sender.setTitle("Create New Account", for: .normal)
            self.loginViewTopConstraint.constant = 60
            self.registerTopConstraint.constant = 1000
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
         for item in self.warningLabel {
             item.isHidden = true
        }
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    @IBAction func selectPic(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        
        User.registerUser(withName: self.registerName.text!, email: self.registerEmail.text!, password: self.registerPassword.text!, profilePic: self.profilePic.image!) { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                    weakSelf?.profilePic.image = UIImage.init(named: "profile pic")
                } else {
                    for item in (weakSelf?.warningLabel)! {
                        item.isHidden = false
                    }
                }
            }
        }
        
    }
    
    func initalWarning() {
        for item in self.warningLabel {
            item.isHidden = true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        self.showLoading(state: true)
        User.loginUser(withEmail: self.loginEmail.text!, password: self.loginPassword.text!) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                } else {
                    for item in (weakSelf?.warningLabel)! {
                        item.isHidden = false
                    }
                }
                weakSelf = nil
            }
        }
    }
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedVC")
        self.show(vc!, sender: nil)
    }
    

}
