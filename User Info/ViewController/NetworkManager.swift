//
//  NetworkManager.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import Foundation

class NetworkManager {
    
    var url = "https://api.github.com/users"
    
    func getURL(completion: @escaping (Result<[UserURL], Error>) ->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) {  data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            var result: [UserURL]?
            do {
                result = try JSONDecoder().decode([UserURL].self, from: data)
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            guard let json = result else { return }
            completion(.success(json))
        }.resume()
    }
    
    func getUser(userURL: String, completion: @escaping (Result<User, Error>) ->()) {
        guard let url = URL(string: userURL) else { return }
        URLSession.shared.dataTask(with: url) {  data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            var result: User?
            do {
                result = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            guard let json = result else { return }
            completion(.success(json))
        }.resume()
    }
}
