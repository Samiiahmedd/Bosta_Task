//
//  GFNavigationController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation
import UIKit

class GFNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
    }
    
    func setUpNavigationController() {
        self.viewControllers = [ProfileViewController()]
    }
}
