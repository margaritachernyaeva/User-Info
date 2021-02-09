//
//  ViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String,
                   message: String?,
                   withActions actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({alert.addAction($0)})
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true)
    }
    
}
