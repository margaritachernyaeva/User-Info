//
//  MainPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

struct FullUserInfo {
    let url: String
    var userInfo: User?
    var image: UIImage?
}

class MainPresenter {
    
    private var view: MainViewProtocol
    private var networkManager = NetworkManager()
    private var users: [FullUserInfo] = []
    var count: Int {
        return users.count
    }
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func getURLs() {
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
                case .success(let userURLs):
                    self.users = userURLs.map { FullUserInfo(url: $0.url ?? "", userInfo: nil, image: nil) }
                    self.view.success()
                }
            }
        })
    }
    
    func getUser(index: Int) -> User? {
        if let user = users[index].userInfo {
           return user
        }
        
        let url = users[index].url
        getUser(userURL: url) { [weak self] (user) in
            guard let self = self else { return }
            var fullUserInfo = self.users[index]
            fullUserInfo.userInfo = user
            self.users[index] = fullUserInfo
            self.view.updateCell(index: index)
        }
        return nil
    }
    
    func getAvatar(index: Int) -> UIImage? {
        if let image = users[index].image {
            return image
        }
        DispatchQueue.global(qos: .background).async {
            guard let avatarURL = self.users[index].userInfo?.avatarURL else { return }
            var avatar = self.users[index].image
            avatar = self.getImage(imageURL: avatarURL)
            self.users[index].image = avatar
        }
        return nil
    }
    
    private func getUser(userURL: String, completion: @escaping (User?) -> ()) {
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
    
    private func getImage(imageURL: String) -> UIImage? {
        let image = networkManager.getImage(stringUrl: imageURL)
        return image
    }
    
    func getDetailInfo(index: Int) -> User? {
        return users[index].userInfo
    }
    
    func getDetailAvatar(index: Int) -> UIImage? {
        return users[index].image
    }
}
