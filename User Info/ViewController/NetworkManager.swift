//
//  NetworkManager.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

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
    
    func getImage(stringUrl: String, completion: @escaping (UIImage) ->()) {
        guard let url = URL(string: stringUrl) else { return }
        let data = try? Data(contentsOf: url)
        guard let imageData = data else { return }
        guard let image = UIImage(data: imageData) else { return }
        completion(image)
    }
}
