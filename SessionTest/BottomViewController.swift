//
//  BottomViewController.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController {
    
    let viewModel = BottomViewModel()
    
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonClicked(_ sender: UIButton) {
        if let productName = productTextField.text {
            viewModel.addProduct(name: productName)
        }
    }
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        if let userName = nameTextField.text {
            viewModel.updateName(name: userName)
        }
    }
}
