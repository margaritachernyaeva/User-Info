//
//  MainPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol {
    init(view: MainViewProtocol, networkManager: NetworkManager, alertManager: AlertManager)
    var usersURL: [UserURL]? { get set }
    var user: User? { get set }
    func getURL()
}

class MainPresenter: MainViewPresenterProtocol {
    
    private var view: MainViewProtocol
    private var networkManager: NetworkManager
    private var alertManager: AlertManager
    var usersURL: [UserURL]?
    var user: User?
    
    required init(view: MainViewProtocol, networkManager: NetworkManager, alertManager: AlertManager) {
        self.view = view
        self.networkManager = networkManager
        self.alertManager = alertManager
        getURL()
    }
    
    func getURL() {
        networkManager.getURL(completion: {  [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
                    self.view.failure(error: error)
                    print(error.localizedDescription)
                case .success(let usersURL):
                    self.usersURL = usersURL
                    self.view.success()
                }
            }
        })
    }
    
    func getUser(userURL: String) {
        networkManager.getUser(userURL: userURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
                    self.view.failure(error: error)
                    print(error.localizedDescription)
                case .success(let user):
                    self.user = user
                    self.view.success()
                }
            }
        }
    }
}
