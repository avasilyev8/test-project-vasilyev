//
//  BaseViewController.swift
//  OnlyProperty-redesign
//
//  Created by madbrains on 21/08/2018.
//  Copyright © 2018 madbrains. All rights reserved.
//

import UIKit
import RxSwift

protocol MvvmConforming: class {
    
    associatedtype ViewModelType: BaseViewModel
    var viewModel: ViewModelType! {get set}
    init(viewModel: ViewModelType)
    
}

class BaseViewController<T: BaseViewModel>: UIViewController, MvvmConforming {
    
    var viewModel: T!
    var shouldHideNavigationBar = false
    
    final var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }
    
    weak var nc: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc = navigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nc?.setNavigationBarHidden(shouldHideNavigationBar, animated: true)
    }
    
    required init(viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
