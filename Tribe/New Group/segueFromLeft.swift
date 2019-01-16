//
//  segueFromLeft.swift
//  Tribe
//
//  Created by Daniel Dodson on 1/8/19.
//  Copyright © 2019 Daniel Dodson. All rights reserved.
//

import Foundation
import UIKit


class segueFromLeft: UIStoryboardSegue {
    override func perform() {
        let secondViewController = self.source
        let ViewController = self.destination
        
        secondViewController.view.superview?.insertSubview(ViewController.view, aboveSubview: secondViewController.view)
        ViewController.view.transform = CGAffineTransform(translationX: -secondViewController.view.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        ViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)},
                       completion: {finished in
                        secondViewController.present(ViewController, animated: false, completion: nil)}
        )
    }
    
}
