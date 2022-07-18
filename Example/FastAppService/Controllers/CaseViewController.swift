//
//  CaseViewController.swift
//  FastAppService_Example
//
//  Created by zhang pan on 2022/7/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import FastExtension

class CaseViewController: UIViewController {
    var example: ExampleCase? = nil
    
    convenience init(exam: ExampleCase) {
        self.init()
        self.example = exam
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if let example = example {
            self.navigationItem.title = example.title
            let _ = example.configView(view: self.view)
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Datas
    
    // MARK: - Views
    
    // MARK: - Lazy
}

