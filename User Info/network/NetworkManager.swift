//
//  NetworkManager.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import UIKit

class NetworkManager {
    
    private var url = "https://api.github.com/users"
    
    //getURL & getUser functions look similar. I should use generics to integrate them into one func, but I had some problems with it, so I leave it for a while
    
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
                guard let json = result else { return }
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
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
                guard let json = result else { return }
                completion(.success(json))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getImage(stringUrl: String) -> UIImage? {
        guard let url = URL(string: stringUrl) else { return nil }
        let data = try? Data(contentsOf: url)
        guard let imageData = data else { return nil }
        guard let image = UIImage(data: imageData) else { return nil }
        return image
    }
}
