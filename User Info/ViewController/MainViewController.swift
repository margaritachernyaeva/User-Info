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
    private var alertManager: AlertManager!
    var user: User?
    var userURL = [UserURL]()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initialize()
        getURL()
    }
    
   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func initialize() {
        networkManager = NetworkManager()
        alertManager = AlertManager()
        presenter = MainPresenter(view: self, networkManager: networkManager, alertManager: alertManager)
    }
    
    private func getURL() {
        presenter?.getURL() 
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.userInfo = self.user
        }
    }
}
    

//MARK: - TableViewDelegate & DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.usersURL?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        guard let url = presenter?.usersURL?[indexPath.row].url else { return cell }
        presenter?.getUser(userURL: url)
        guard let user = presenter?.user else { return cell }
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
    
    func failure(error: Error) {
        alertManager.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
    
    func success() {
        tableView.reloadData()
    }
}



