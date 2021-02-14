//
//  MainPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

protocol MainViewProtocol {
    func success()
    func failure(error: Error)
    func getURL()
}

class MainPresenter {
    
    private var view: MainViewProtocol
    private var networkManager: NetworkManager
    var usersURL: [UserURL]?
    
    required init(view: MainViewProtocol, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func getURL() {
        networkManager.getURL(completion: {  [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.view.failure(error: error)
                    print(error.localizedDescription)
                case .success(let usersURL):
                    self.usersURL = usersURL
                    self.view.success()
                }
            }
        })
    }
    
    func getUser(userURL: String, completion: @escaping (User?) -> ()) {
        networkManager.getUser(userURL: userURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.view.failure(error: error)
                    print(error.localizedDescription)
                case .success(let user):
                    completion(user)
                }
            }
        }
    }
    
    func getImage(imageURL: String, completion: @escaping (UIImage) -> ()) {
        networkManager.getImage(stringUrl: imageURL) { (image) in
            completion(image)
        }
    }
}
