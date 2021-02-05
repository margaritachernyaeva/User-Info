//
//  ViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit

class ViewController: UIViewController {

    var users = [User]()
    var margaritasURL = "https://api.github.com/users/margaritachernyaeva"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getData(from: margaritasURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(users.count)
    }
    
   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data, let _ = response else { return }
            var result: User?
            do {
                result = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            guard let json = result else { return }
            self.users.append(json)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let user = users[indexPath.row]
        // " " чтобы ничего не плыло, если значение nil
        cell.nameLabel.text = user.name ?? " "
        cell.emailLabel.text = user.email ?? " "
        if let followers = user.followers {
            cell.followersLabel.text = String(followers)
        } else {
            cell.followersLabel.text = " "
        }
        if let following = user.following {
            cell.followingLabel.text = String(following)
        } else {
            cell.followingLabel.text = " "
        }
        // тут приводим дату к читаемому виду
        cell.dateLabel.text = String((user.created_at ?? "").dropLast(10))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

