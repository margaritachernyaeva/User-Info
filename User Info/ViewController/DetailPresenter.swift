//
//  DetailPresenter.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/10/21.
//

import Foundation
protocol DetailViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol DetailViewPresenterProtocol {
    init(view: DetailViewProtocol, networkManager: NetworkManager)
    var user: User? { get set }
}

class DetailPresenter: DetailViewPresenterProtocol {
    private var view: DetailViewProtocol?
    private var networkManager: NetworkManager?
    var user: User?
    required init(view: DetailViewProtocol, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
    }

}
