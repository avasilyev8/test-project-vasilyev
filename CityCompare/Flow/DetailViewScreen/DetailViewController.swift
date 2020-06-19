//
//  DetailViewController.swift
//  CityCompare
//
//  Created by  Mad Brains on 06/02/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController<DetailViewModel> {
    
    @IBOutlet weak var summaryInfoLabel: UITextView!
    @IBOutlet weak var housingLabel: UILabel!
    @IBOutlet weak var costOfLivingLabel: UILabel!
    @IBOutlet weak var startupsLabel: UILabel!
    @IBOutlet weak var ventureCapitalLabel: UILabel!
    @IBOutlet weak var travelConnectivityLabel: UILabel!
    @IBOutlet weak var commuteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        bind()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let rb = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rb
        title = viewModel.city
    }
    
    @objc func addButtonTapped() {
        viewModel.saveCityData()
        viewModel.passCityData()
    }
    
    func bind() {
        viewModel.detailScreenModel.onNext(disposeTo: disposeBag) { [weak self] in
            guard let model = $0 else {
                return
            }            
            self?.notifyViewAboutChanges(model: model)
        }
    }
    
    func notifyViewAboutChanges(model: DetailViewScreenModel) {
        summaryInfoLabel.attributedText = model.summary
        housingLabel.text = model.formattedStringForCategory[.housing]
        costOfLivingLabel.text = model.formattedStringForCategory[.costOfLiving]
        startupsLabel.text = model.formattedStringForCategory[.startups]
        ventureCapitalLabel.text = model.formattedStringForCategory[.ventureCapital]
        travelConnectivityLabel.text = model.formattedStringForCategory[.travelConnectivity]
        commuteLabel.text = model.formattedStringForCategory[.commute]
    }
    
}

