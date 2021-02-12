//
//  User.swift
//  User
//
//  Created by Маргарита Черняева on 2/5/21.
//

import Foundation

struct User: Codable {
    let avatar_url : String?
    let name : String?
    let email : String?
    let followers : Int?
    let following : Int?
    let created_at : String?
    let company: String?
    let location: String?
    let public_repos: Int?
}

extension User {
    // this helps to transfer image from MainVC to DetailVC
    var imageData: Data? {
        guard let stringURL = avatar_url else { return nil }
        if let url = URL(string: stringURL) {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}

struct UserURL: Codable {
    let url: String?
}


