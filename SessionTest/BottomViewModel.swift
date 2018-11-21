//
//  BottomViewModel.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import Foundation
import RxSwift

class BottomViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    
    func addProduct(name: String) {
        BusinessLogic.shared.addProductFlow(name: name)
            .subscribe(onNext: { result in
                print("Result :\(result)")
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateName(name: String) {
        BusinessLogic.shared.updateNameFlow(name: name)
            .subscribe(onNext: { result in
                print("Result :\(result)")
            })
            .disposed(by: self.disposeBag)
    }
}
