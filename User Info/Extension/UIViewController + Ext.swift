//
//  UIViewController + Ext.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import UIKit

extension UIViewController {
    func showAlert(withTitle title: String,
                   message: String?,
                   withActions actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({alert.addAction($0)})
        present(alert, animated: true)
    }
}
