//
//  Session.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

// MARK: CustomerExtension extension
extension CustomerExtension where Base == Session {
    
    func fetch() -> (String?, String?) {
        return self.base.fetchCustomer()
    }
    
    func refreshObservable() -> Observable<Bool> {
        return self.base.customerRefreshSubject.asObservable()
    }
    
    func save(name: String?, phone: String?) {
        return self.base.saveCustomer(name: name, phone: phone)
    }
    
    func refresh() {
        self.base.customerRefreshSubject.onNext(true)
    }
}

// MARK: ProductExtension extension
extension ProductExtension where Base == Session {
    
    func fetch() -> [String]? {
        return self.base.fetchProducts()
    }
    
    func refreshObservable() -> Observable<Bool> {
        return self.base.productsRefreshSubject.asObservable()
    }
    
    func save(names: [String]?) {
        return self.base.saveProducts(names: names)
    }
    
    func refresh() {
        self.base.productsRefreshSubject.onNext(true)
    }
}


class Session: CustomerExtensionCompatible, ProductExtensionCompatible {
    
    lazy var stack: CoreDataStack = CoreDataStack(modelName: "Session")
    let customerRefreshSubject = PublishSubject<Bool>()
    let productsRefreshSubject = PublishSubject<Bool>()

    static let shared: Session = {
        return Session()
    }()
    let disposeBag = DisposeBag()
    
    private init() {
    
    }
    
    fileprivate func saveCustomer(name: String?, phone: String?) {
        if name != nil && phone != nil {
            self.deleteEntity(entity: "CustomerMO")
            let customerMO = CustomerMO(context: self.stack.mainContext)
            customerMO.name = name
            customerMO.phoneNumber = phone
        }
    }
    
    fileprivate func saveProducts(names: [String]?) {
        if let productNames = names {
            self.deleteEntity(entity: "ProductMO")
            productNames.forEach { productName in
                let productMO = ProductMO(context: self.stack.mainContext)
                productMO.productName = productName
            }
        }
    }
    
    private func deleteEntity(entity: String) {
        var objects: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        do {
            objects = try self.stack.mainContext.fetch(fetchRequest)
            for obj in objects {
                self.stack.mainContext.delete(obj)
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
    }
    
    
    fileprivate func fetchCustomer() -> (String?, String?) {
        let fetchRequest: NSFetchRequest<CustomerMO> = CustomerMO.fetchRequest()
        do {
            let customers = try self.stack.primaryContext.fetch(fetchRequest)
            if customers.count > 0, let customerMO = customers.first {
                return (customerMO.name, customerMO.phoneNumber)
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        self.refreshCustomer()
        return (nil, nil)
    }
    
    fileprivate func fetchProducts() -> [String]? {
        let fetchRequest: NSFetchRequest<ProductMO> = ProductMO.fetchRequest()
        do {
            let products = try self.stack.primaryContext.fetch(fetchRequest)
            if products.count > 0 {
                return products.filter{ $0.productName != nil }.map{ $0.productName ?? "" }
            }
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        self.refreshProducts()
        return nil
    }
    
    private func refreshCustomer() {
        BusinessLogic.shared.fetchCustomer()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] customer in
                self.saveCustomer(name: customer.0, phone: customer.1)
                self.customerRefreshSubject.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func refreshProducts() {
        BusinessLogic.shared.fetchProducts()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] products in
                self.saveProducts(names: products)
                self.productsRefreshSubject.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
}
