//
//  ViewController.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/4/21.
//

import UIKit

protocol MainViewProtocol {
    func success()
    func failure(error: Error)
}

class MainViewController: UIViewController {

    private var presenter: MainPresenter?
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        getURL()
        setupTableView()
    }
    
   private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 154
    }

    private func initialize() {
        presenter = MainPresenter(view: self)
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
                cell.configure(stringURL: stringURL, presenter: presenter)
                cell.selectionStyle = .none
                return cell
        }
        return MainTableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
//            let user = presenter?.usersURL?[indexPath.row]
//        self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }
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



