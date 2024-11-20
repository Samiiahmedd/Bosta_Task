//
//  UIView+Extensions.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 20/11/2024.
//

import Foundation
import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
