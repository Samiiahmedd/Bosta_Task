//
//  AlertManager.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation
import UIKit

class AlertManager {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}


