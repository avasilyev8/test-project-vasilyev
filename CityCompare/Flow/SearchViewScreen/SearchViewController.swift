//
//  SearchViewController.swift
//  CityCompare
//
//  Created by  Mad Brains on 05/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SVProgressHUD

class SearchViewController: BaseViewController<SearchViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchViewModelDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!   
    @IBOutlet weak var invitationLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureTableView()
        configureSearchBar()
        setupBackgroundView()
        bind()
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter your most desired city"
    }
    
    func configureTableView() {
        shouldHideNavigationBar = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(forClass: SearchCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func setupBackgroundView() {
        invitationLabel.font = UIFont.boldSystemFont(ofSize: 22)
        invitationLabel.text = "Please type any city"
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(retryFetching), for: .touchUpInside)
        tableView.backgroundView = messageView
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
    }
    
    func bind() {
        viewModel.cellViewModels.onNext(disposeTo: disposeBag) { [weak self] _ in
            self?.updateTableBackgroundView()
            self?.tableView.reloadData()
        }
    }
    
    private func updateTableBackgroundView() {
        if !viewModel.cellViewModels.get().isEmpty {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.get().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchCell.self), for: indexPath) as! SearchCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let vm = viewModel?.cellViewModel(at: indexPath) else {
            return
        }
        viewModel.didSelect(detailCellModel: vm)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.fetchCityList(text: searchBar.text)
        dismissKeyboard()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func retryFetching() {
        viewModel?.fetchCityList(text: searchBar.text)
    }
    
    func searchViewModel(_ searchViewModel: SearchViewModel, didFailFetchingWithError error: String) {
        invitationLabel.text = error
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
        retryButton.isHidden = false        
    }
    
    func searchViewModel(_ searchViewModel: SearchViewModel, didFailMappingWithError error: String) {
        invitationLabel.text = error
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
        retryButton.isHidden = true
    }
    
    func searchViewModel(startLoading searchViewModel: SearchViewModel) {
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func searchViewModel(endLoading searchViewModel: SearchViewModel) {
        SVProgressHUD.dismiss()
    }
    
}
