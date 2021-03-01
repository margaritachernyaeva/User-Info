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
    
    func configure(userInfo: User?, avatarImage: UIImage?) {
        nameLabel.text = userInfo?.name ?? " "
        emailLabel.text = userInfo?.email ?? " "
        dateLabel.text = String((userInfo?.createdAt ?? "").dropLast(10))
        
        if let followers = userInfo?.followers {
            followersLabel.text = String(followers)
        } else {
            followersLabel.text = " "
        }
        if let following = userInfo?.following {
            followingLabel.text = String(following)
        } else {
            followingLabel.text = " "
        }
        avatar.image = avatarImage ?? nil
        avatar.layer.cornerRadius = self.avatar.frame.width / 2
        avatar.clipsToBounds = true
    }
    
}
