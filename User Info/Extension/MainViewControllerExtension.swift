//
//  MainViewControllerExtension.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import UIKit

extension MainViewController: MainViewProtocol {
    
    func failure(error: Error, alertManager: AlertManager) {
        alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
    
    func success(tableView: UITableView) {
        tableView.reloadData()
    }
}
