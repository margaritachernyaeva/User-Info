//
//  DetailPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import UIKit

class DetailPresenter {
    
    private var view: DetailViewProtocol?
    var user: User?
    var avatar: UIImage?
    
    required init(view: DetailViewProtocol?, user: User?) {
        self.view = view
        self.user = user
    }
    
    func setupUser() {
        self.view?.setupUser(user: user)
    }
}
