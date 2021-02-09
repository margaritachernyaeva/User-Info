//
//  NetworkManager.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/8/21.
//

import Foundation

class NetworkManager {
    
    var url = "https://api.github.com/users"
    let alertManager = AlertManager()
    
    func getURL(completion: @escaping (Result<[UserURL], Error>) ->()) {
        print("DERVV")

        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                self.alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
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
}
