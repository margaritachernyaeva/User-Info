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
    var user: User?
    var userURL = [UserURL]()
    var users: [User]?
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
        presenter = MainPresenter(view: self, networkManager: networkManager)
    }
    
    private func getURL() {
        presenter?.getURL() 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailVC = segue.destination as? DetailTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let url = presenter?.usersURL?[indexPath.row].url else { return }
            presenter?.getUser(userURL: url) { userInfo in
                detailVC.userInfo = userInfo
            }
        }
    }
}

//MARK: - TableViewDelegate & DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.usersURL?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        guard let presenter = presenter else { return UITableViewCell() }
        guard let stringURL = presenter.usersURL?[indexPath.row].url else { return cell }
        cell.prepareForReuse()
        cell.configure(stringURL: stringURL, presenter: presenter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func failure(error: Error) {
       showAlert(withTitle: "Error", message: error.localizedDescription)
    }
    
    func success() {
      tableView.reloadData()
    }
}


