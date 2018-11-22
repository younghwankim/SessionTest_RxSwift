//
//  BottomViewController.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import UIKit
import RxCocoa

/*
 In RxSwift – and especially with RxCocoa – there are some good guidelines to follow when choosing to use weak, unowned or nothing at all:
 • nothing: Inside singletons or a view controller which are never released (e.g. the root view controller).
 • unowned: Inside all view controllers which are released after the closure task is performed.
 • weak: Any other case.
 */
class BottomViewController: UIViewController {
    
    let viewModel = BottomViewModel()
    
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Bind UI
        addButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                if let productName = self.productTextField.text {
                    self.viewModel.addProduct(name: productName)
                }
            }).disposed(by: viewModel.disposeBag)
        
        updateButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                if let userName = self.nameTextField.text {
                    self.viewModel.updateName(name: userName)
                }
            }).disposed(by: viewModel.disposeBag)
    }
}
