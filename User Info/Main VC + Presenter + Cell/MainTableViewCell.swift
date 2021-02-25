//
//  CustomTableViewCell.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit
// This class doesn't match to MVP Pattern. I couldn't do anything with it yet. But I tried
class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // this var is used for transfering data to DetailVC
    var user: User?
    
    //prepaping cells to be reused
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
        presenter.getUser(userURL: stringURL) { [weak self] userInfo in
            // TO DO 
            guard let self = self else { return }
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
                self.dateLabel.text = String((userInfo.createdAt ?? "").dropLast(10))
                
                // downloading images
                DispatchQueue.global(qos: .background).async {
                    guard let imageURL = userInfo.avatarURL else { return }
                    let image = presenter.getImage(imageURL: imageURL)
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
}
