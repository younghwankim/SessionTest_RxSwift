//
//  TopViewModel.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TopViewModel: NSObject {
    let session: Session = {
        return Session.shared
    }()
    let disposeBag = DisposeBag()
    private let refreshRelay = PublishRelay<Bool>()
    var refreshObservable: Observable<Bool> {
        return refreshRelay.asObservable()
    }
    var name: String?
    var phone: String?
    var productNames: [String]?
    
    override init() {
        super.init()
        
        //binding first
        session.customer.refreshObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                let aCustomer = self.session.customer.fetch()
                self.name = aCustomer.0
                self.phone = aCustomer.1
                self.refreshRelay.accept(true)
            })
            .disposed(by: self.disposeBag)
        
        session.product.refreshObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.productNames = self.session.product.fetch()
                self.refreshRelay.accept(true)
            })
            .disposed(by: self.disposeBag)
        
        //initial value
        let customer = session.customer.fetch()
        self.name = customer.0
        self.phone = customer.1
        self.productNames = session.product.fetch()
    }
    
    func productString() -> String {
        if let pNames = productNames {
            return pNames.joined(separator: ", ")
        }
        return ""
    }
}
