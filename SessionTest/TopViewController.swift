//
//  TopViewController.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import UIKit
import RxSwift
/*
 In RxSwift – and especially with RxCocoa – there are some good guidelines to follow when choosing to use weak, unowned or nothing at all:
    • nothing: Inside singletons or a view controller which are never released (e.g. the root view controller).
    • unowned: Inside all view controllers which are released after the closure task is performed.
    • weak: Any other case.
 */
class TopViewController: UIViewController {

    let viewModel = TopViewModel()
    
    @IBOutlet weak var productsTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //subscribe first
        viewModel.refreshObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.nameLabel.text = self.viewModel.name ?? ""
                self.productsTextView.text = self.viewModel.productString()
            })
            .disposed(by: self.viewModel.disposeBag)
        
        //initial value
        nameLabel.text = viewModel.name ?? ""
        productsTextView.text = viewModel.productString()
        
    }
}
