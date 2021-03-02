//
//  DetailTableViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/5/21.
//

import UIKit


protocol DetailViewProtocol {
    func setupUser(user: User?)
}

class DetailTableViewController: UITableViewController {
    
    var presenter: DetailPresenter?
    var userInfo: User?

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var followersCountLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var publicRepositoriesCountLabel: UILabel!
    @IBOutlet private weak var dateOfCreation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupUser(user: userInfo)
    }
    
    private func initialize() {
        presenter = DetailPresenter(view: self, user: userInfo)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}

//MARK: - DetailViewProtocol

extension DetailTableViewController: DetailViewProtocol {
    
    func setupUser(user: User?) {
        guard let userInfo = user else { return }
        nameLabel.text = userInfo.name ?? " "
        emailLabel.text = userInfo.email ?? " "
        followersCountLabel.text = userInfo.followers == nil ? " "
            : String(userInfo.followers ?? 0)
        followingCountLabel.text = userInfo.following == nil ? " "
            : String(userInfo.following ?? 0)
        locationLabel.text = userInfo.location ?? " "
        companyLabel.text = userInfo.company ?? " "
        publicRepositoriesCountLabel.text = userInfo.publicRepos == nil ? " " : String(userInfo.publicRepos ?? 0)
        let date = String((userInfo.createdAt ?? "").dropLast(10))
        dateOfCreation.text = "Account was created \(date)"
        if let imageData = userInfo.imageData {
            avatarImageView.image = UIImage(data: imageData)
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "default_photo")
                }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }
}
