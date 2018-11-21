//
//  BusinessLogic.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import Foundation
import RxSwift

class BusinessLogic {
    let disposeBag = DisposeBag()
    
    var name = "Terry Fox"
    var phone = "416-900-1234"
    var productNames: [String] = []
    
    static let shared: BusinessLogic = {
        return BusinessLogic()
    }()
    let session: Session = {
        return Session.shared
    }()
    
    private init() {
        self.productNames.append("Toy Story")
    }
    
    func fetchCustomer() -> Observable<(String, String)> {
        return Observable.create { observer in
            observer.onNext((self.name, self.phone))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func updateName(name: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.name = name
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func updateNameFlow(name: String) -> Observable<Bool> {
        return Observable.create { observer in
            
            self.updateName(name: name)
                .filter { result in
                    if !result {
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    return result
                }
                .flatMapLatest { _ -> Observable<(String, String)> in
                    self.fetchCustomer()
                }
                .subscribe(onNext: { [unowned self] customer in
                    self.session.customer.save(name: customer.0, phone: customer.1)
                    self.session.customer.refresh()
                    observer.onNext(true)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func fetchProducts() -> Observable<[String]> {
        return Observable.create { observer in
            observer.onNext(self.productNames)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addProduct(name: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.productNames.append(name)
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addProductFlow(name: String) -> Observable<Bool> {
        return Observable.create { observer in
            
            self.addProduct(name: name)
                .filter { result in
                    if !result {
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    return result
                }
                .flatMapLatest { _ -> Observable<[String]> in
                    self.fetchProducts()
                }
                .subscribe(onNext: { [unowned self] products in
                    self.session.product.save(names: products)
                    self.session.product.refresh()
                    observer.onNext(true)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
