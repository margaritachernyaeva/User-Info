//
//  MainPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol {
    init(view: MainViewProtocol, networkManager: NetworkManager, alertManager: AlertManager)
    var usersURL: [UserURL]? { get set }
    func getURL()
}

class MainPresenter: MainViewPresenterProtocol {
    
    private var view: MainViewProtocol
    private var networkManager: NetworkManager
    private var alertManager: AlertManager
    var usersURL: [UserURL]?
    
    required init(view: MainViewProtocol, networkManager: NetworkManager, alertManager: AlertManager) {
        self.view = view
        self.networkManager = networkManager
        self.alertManager = alertManager
        getURL()
    }
    
    func getURL() {
        networkManager.getURL(completion: { (result) in
            switch result {
            case .failure(let error):
                self.alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            case .success(let usersURL):
                self.usersURL = usersURL
                print(usersURL)
            }
        })
    }
}
