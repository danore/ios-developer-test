//
//  MainTabViewController.swift
//  vehicles
//
//  Created by Desarollo on 5/15/20.
//  Copyright © 2020 Desarollo. All rights reserved.
//

import Foundation
import UIKit

class MainTabViewController:  UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        var controller = viewController as! TabViewController
        
    }
    
}
