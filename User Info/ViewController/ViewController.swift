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
//        downloadAvatars()
    }
    
   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getData(from url: String) {
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            detailVC.userInfo = user
        }
    }
}
    

//MARK: - TableViewDelegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(users.count)
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
        // загружаем аватары
        DispatchQueue.global(qos: .background).async {
            guard let stringURL = user.avatar_url else { return }
            guard let url = URL(string: stringURL) else { return }
            let data = try? Data(contentsOf: url)
            let image: UIImage?
            guard let imageData = data else { return }
            image = UIImage(data: imageData)
            DispatchQueue.main.async {
                    cell.avatar.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

