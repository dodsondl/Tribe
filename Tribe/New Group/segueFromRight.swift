//
//  segueFromRight.swift
//  Tribe
//
//  Created by Daniel Dodson on 1/8/19.
//  Copyright © 2019 Daniel Dodson. All rights reserved.
//

import Foundation

import UIKit

class segueFromRight: UIStoryboardSegue {
    override func perform() {
        let ViewController = self.source
        let secondViewController = self.destination
        
        ViewController.view.superview?.insertSubview(secondViewController.view, aboveSubview: ViewController.view)
        secondViewController.view.transform = CGAffineTransform(translationX: ViewController.view.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        secondViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)},
                       completion: {finished in
                        ViewController.present(secondViewController, animated: false, completion: nil)}
        )
        
    }
}
