//
//  User.swift
//  User
//
//  Created by Маргарита Черняева on 2/5/21.
//

import Foundation

struct User: Codable {
    let avatarURL : String?
    let name : String?
    let email : String?
    let followers : Int?
    let following : Int?
    let createdAt : String?
    let company: String?
    let location: String?
    let publicRepos: Int?

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case publicRepos = "public_repos"
        case name
        case email
        case followers
        case following
        case company
        case location
    }
}
    
extension User {
    // this helps to transfer image from MainVC to DetailVC
    var imageData: Data? {
        guard let stringURL = avatarURL else { return nil }
        if let url = URL(string: stringURL) {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}

struct UserURL: Codable {
    let url: String?
}


