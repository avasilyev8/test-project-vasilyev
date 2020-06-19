//
//  RxProperty.swift
//  OnlyProperty-redesign
//
//  Created by madbrains on 27/08/2018.
//  Copyright © 2018 madbrains. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RxProperty<Element> {
    private let ownerId: String
    private let relay: BehaviorRelay<Element>
    private var driver: Driver<Element> {
        return relay.asDriver(onErrorRecover: { _ in fatalError() })
    }
    
    init(ownerId: String = #file, value: Element) {
        self.ownerId = ownerId
        relay = BehaviorRelay<Element>(value: value)
    }
    
    func set(ownerId: String = #file, _ value: Element)  {
        assert(self.ownerId == ownerId)
        relay.accept(value)
    }
    
    func get() -> Element {
        return relay.value
    }
    
    func onNext(disposeTo disposeBag: DisposeBag, _ onNext: @escaping ((Element) -> Void)) {
        driver.drive(onNext: onNext).disposed(by: disposeBag)
    }
}

class RxPublishProperty<Element> {
    private let ownerId: String
    private let relay: PublishRelay<Element>
    private var driver: Driver<Element> {
        return relay.asDriver(onErrorRecover: { _ in fatalError() })
    }
    
    init(ownerId: String = #file) {
        self.ownerId = ownerId
        relay = PublishRelay<Element>()
    }
    
    func set(ownerId: String = #file, _ value: Element)  {
        assert(self.ownerId == ownerId)
        relay.accept(value)
    }
    
    func onNext(disposeTo disposeBag: DisposeBag, _ onNext: @escaping ((Element) -> Void)) {
        driver.drive(onNext: onNext).disposed(by: disposeBag)
    }
}
