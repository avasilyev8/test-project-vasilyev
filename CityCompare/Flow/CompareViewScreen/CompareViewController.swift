//
//  CompareViewController.swift
//  CityCompare
//
//  Created by  Mad Brains on 31/01/2019.
//  Copyright © 2019 Mad Brains. All rights reserved.
//

import UIKit
import Charts

class CompareViewController: BaseViewController<CompareViewModel>, ChartViewDelegate, IAxisValueFormatter {
    
    @IBOutlet weak var chartView: RadarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureChartView()
        bind()
    }
    

    func configureChartView() {
        let image = UIImage(named: "mixer2")
        let rb = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(filterTapped))
        navigationItem.rightBarButtonItem = rb
        title = "Comparison"
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.webAlpha = 1
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .black
        xAxis.labelCount = 17
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 17
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 8
        yAxis.drawLabelsEnabled = false
        
        let legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.font = .systemFont(ofSize: 15, weight: .medium)
        legend.xEntrySpace = 7
        legend.yEntrySpace = 5
        legend.textColor = .black
        
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    @objc func filterTapped() {
        if viewModel.checkScreenAvailability() {
            viewModel?.filterCategories()
        } else {
            let alert = UIAlertController(title: "Warning", message: "Add cities for compare first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Забей + забудь", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func bind() {
        viewModel.chartData.onNext(disposeTo: disposeBag) { [weak self] in
            self?.chartView.data = $0
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let strToShow = Array(viewModel.filteredDict.keys)
        return strToShow[Int(value) % strToShow.count]
    }
    
}

