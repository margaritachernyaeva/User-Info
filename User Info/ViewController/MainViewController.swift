//
//  ViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit

class MainViewController: UIViewController {

    private var presenter: MainPresenter?
    private var networkManager: NetworkManager!
    var users = [User]()
    var userURL = [UserURL]()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initialize()
        networkManager.getURL { (result) in
            switch result {
            case .success(let userURL):
                print(userURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func initialize() {
        networkManager = NetworkManager()
        presenter = MainPresenter(view: self, networkManager: networkManager)
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(users.count)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let user = users[indexPath.row]
        // " " чтобы ничего не плыло, если значение nil
        cell.nameLabel.text = user.name ?? " "
        cell.emailLabel.text = "email: \(user.email ?? " ")"
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
        if cell.avatar.image == nil {
            cell.avatar.image = #imageLiteral(resourceName: "default_photo")
        }
        cell.avatar.layer.cornerRadius = cell.avatar.frame.width / 2
        cell.avatar.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

extension MainViewController: MainViewProtocol {
    
}



