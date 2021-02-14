//
//  ViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit

class MainViewController: UIViewController {

    private var presenter: MainPresenter?
    private var networkManager = NetworkManager()
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
        presenter = MainPresenter(view: self, networkManager: networkManager)
    }
    
    // here we receive an array of user's urls at Presenter
    internal func getURL() {
        presenter?.getURL() 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detailVC = segue.destination as? DetailTableViewController,
           let userInfo = (sender as? MainTableViewCell)?.user {
            detailVC.userInfo = userInfo
        }
    }
}

//MARK: - TableViewDelegate & DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.usersURL?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell,
           let presenter = presenter,
           let stringURL = presenter.usersURL?[indexPath.row].url {
                cell.prepareForReuse()
                cell.configure(stringURL: stringURL, presenter: presenter)
                cell.selectionStyle = .none
                return cell
        }
        return MainTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
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



