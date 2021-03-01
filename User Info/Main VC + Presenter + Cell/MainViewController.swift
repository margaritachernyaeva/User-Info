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
    func updateCell(index: Int)
}

class MainViewController: UIViewController {

    private var presenter: MainPresenter?
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
        presenter?.getURLs()
    }
}

//MARK: - TableViewDelegate & DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return MainTableViewCell() }
        let user = presenter?.getUser(index: indexPath.row)
        let avatar = self.presenter?.getAvatar(index: indexPath.row)
        cell.configure(userInfo: user, avatarImage: avatar)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
                detailVC.userInfo = self.presenter?.getUser(index: indexPath.row)
                self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func updateCell(index: Int) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
    
    func failure(error: Error) {
        showAlert(withTitle: "Error", message: error.localizedDescription)
    }
    
    func success() {
        tableView.reloadData()
    }
}



