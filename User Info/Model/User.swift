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
}


