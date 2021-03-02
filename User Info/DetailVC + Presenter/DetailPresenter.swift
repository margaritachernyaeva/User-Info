//
//  DetailPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import UIKit

//TODO: -
// This class must contain info about user and represent infomantion to DetailVC. In process
class DetailPresenter {

    private var view: DetailViewProtocol?

    
    required init(view: DetailViewProtocol?) {
        self.view = view
    }
    
    func setupUser() {
//        self.view?.setupUser(user: user)
    }
}
