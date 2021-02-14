//
//  CustomTableViewCell.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // this var used for transfering data to DetailVC
    var user: User?
    
    //prepape cells to be reused
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        nameLabel.text = nil
        emailLabel.text = nil
        followersLabel.text = nil
        followingLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(stringURL: String, presenter: MainPresenter) {
        // Info
        presenter.getUser(userURL: stringURL) { userInfo in
            self.user = userInfo
            guard let userInfo = userInfo else { return }
            DispatchQueue.main.async {
                self.nameLabel.text = userInfo.name ?? " "
                self.emailLabel.text = "email: \(userInfo.email ?? " ")"
                if let followers = userInfo.followers {
                    self.followersLabel.text = String(followers)
                } else {
                    self.followersLabel.text = " "
                }
                if let following = userInfo.following {
                    self.followingLabel.text = String(following)
                } else {
                    self.followingLabel.text = " "
                }
                // Changing date size to make it readable
                self.dateLabel.text = String((userInfo.created_at ?? "").dropLast(10))
                // downloading images
                DispatchQueue.global(qos: .background).async {
                    guard let imageURL = userInfo.avatar_url else { return }
                    presenter.getImage(imageURL: imageURL) { image in
                        DispatchQueue.main.async {
                            self.avatar.image = image
                        }
                    }
                }
            }
        }
        //some settings
        self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
        self.avatar.clipsToBounds = true
    }
}

extension MainTableViewCell: MainViewProtocol {
    func success() {
        <#code#>
    }
    
    func failure(error: Error) {
        <#code#>
    }
    
    func getURL() {
        <#code#>
    }
    
    
}
