//
//  TopViewController.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import UIKit
import RxSwift

class TopViewController: UIViewController {

    let viewModel = TopViewModel()
    
    @IBOutlet weak var productsTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //binding first
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
