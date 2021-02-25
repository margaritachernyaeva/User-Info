//
//  MainPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

class MainPresenter {
    
    private var view: MainViewProtocol
    private var networkManager = NetworkManager()
    var usersURL: [UserURL]?
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getURL() {
        let view = self.view
        networkManager.getURL(completion: { [weak self] result in
            guard let self = self else {
                view.failure(error: NetworkError.unknownError)
                return
            }
            DispatchQueue.main.async {
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
        let view = self.view
        networkManager.getUser(userURL: userURL) { [weak self] result in
            guard let self = self else {
                view.failure(error: NetworkError.unknownError)
                return
            }
            DispatchQueue.main.async {
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
    
    func getImage(imageURL: String) -> UIImage? {
        let image = networkManager.getImage(stringUrl: imageURL)
        return image
    }
}
