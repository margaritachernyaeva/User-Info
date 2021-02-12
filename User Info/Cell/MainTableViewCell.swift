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
        presenter.getUser(userURL: stringURL)
        DispatchQueue.main.async {
            guard let user = presenter.user else { return }
            self.nameLabel.text = user.name ?? " "
            self.emailLabel.text = "email: \(user.email ?? " ")"
            if let followers = user.followers {
                self.followersLabel.text = String(followers)
            } else {
                self.followersLabel.text = " "
            }
            if let following = user.following {
                self.followingLabel.text = String(following)
            } else {
                self.followingLabel.text = " "
            }
            // Changing date size to become readable
            self.dateLabel.text = String((user.created_at ?? "").dropLast(10))
            // downloading images
            DispatchQueue.global(qos: .background).async {
                guard let imageURL = user.avatar_url else { return }
                presenter.getImage(imageURL: imageURL) { image in
                    DispatchQueue.main.async {
                        self.avatar.image = image
                    }
                }
            }
        }
        //some settings
        self.avatar.layer.cornerRadius = self.avatar.frame.width / 2
        self.avatar.clipsToBounds = true
    }
    
    func configureWithImage(stringURL: String, presenter: MainPresenter) {
        presenter.getImage(imageURL: stringURL) { image in
            DispatchQueue.main.async {
            self.avatar.image = image
            }
        }
    }
}
