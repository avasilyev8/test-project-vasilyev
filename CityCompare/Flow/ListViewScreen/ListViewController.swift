//
//  ListViewController.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController<ListViewModel>, UITableViewDataSource, UITableViewDelegate {   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var invitationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
    }
    
    func configureTableView() {
        shouldHideNavigationBar = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(forClass: ListViewCell.self)
        invitationLabel.text = "There is no favourites yet"
        invitationLabel.font = UIFont.boldSystemFont(ofSize: 22)
        tableView.backgroundView = invitationLabel
        tableView.backgroundView?.isHidden = true
    }
    
    func bind() {
        viewModel.listViewCellModels.onNext(disposeTo: disposeBag) { [weak self] _ in
            self?.updateTableBackground()
            self?.tableView.reloadData()
        }
    }
    
    private func updateTableBackground() {
        let check = viewModel.listViewCellModels.get().isEmpty
        tableView.backgroundView?.isHidden = !check
        tableView.separatorStyle = check ? .none : .singleLine       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forClass: ListViewCell.self, for: indexPath)
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listViewCellModels.get().count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteAction(at: indexPath)])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            self?.viewModel.removeData(at: indexPath)
            success(true)
        }
        action.backgroundColor = .red
        return action
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isButtonAvailable = self.viewModel.checkButtonAvailability()
        if isButtonAvailable {
            return UISwipeActionsConfiguration(actions: [addToComparison(at: indexPath)])
        } else {
            let alert = UIAlertController(title: "Внимание", message: "Вы уже добавили максимальное число городов для сравнения", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Понял + принял", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    func addToComparison(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Compare") { [weak self] (action, view, success) in
            if let cellViewModel = self?.viewModel.getCellViewModel(at: indexPath) {
                self?.viewModel.addChoosenCityToComparisonScreen(listViewCellModel: cellViewModel)
                success(true)
            }
        }
        action.backgroundColor = .purple
        return action
    }
    
}
