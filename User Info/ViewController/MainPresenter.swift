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
    init(view: MainViewProtocol, networkManager: NetworkManager)
    var usersURL: [UserURL]? { get set }
    func getURL()
}

class MainPresenter: MainViewPresenterProtocol {
    
    private var view: MainViewProtocol
    private var networkManager: NetworkManager?
    var usersURL: [UserURL]?
    
    required init(view: MainViewProtocol, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
        getURL()
    }
    
    func getURL() {
        networkManager?.getURL(completion: { (usersURL, error) in
            print(usersURL ?? "DFRG")
        })
    }
}
