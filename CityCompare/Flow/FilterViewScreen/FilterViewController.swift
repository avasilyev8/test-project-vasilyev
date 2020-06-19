//
//  FilterViewController.swift
//  CityCompare
//
//  Created by  Mad Brains on 26/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController<FilterViewModel>, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(forClass: FilterViewCell.self)
    }
    
    func bind() {
        viewModel.filterViewCellModels.onNext(disposeTo: disposeBag) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterViewCellModels.get().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forClass: FilterViewCell.self, for: indexPath)
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            viewModel.sendCategoriesBack()
        }
    }
    
}

