//
//  CaseTableViewController.swift
//  FAService
//
//  Created by pan zhang on 2022/7/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class CaseTableViewController: UITableViewController {
    
    var example: ExampleCase? = nil
    
    convenience init(exam: ExampleCase, style: UITableViewStyle) {
        self.init(style: style)
        self.example = exam
    }
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    // MARK: - Datas
    
    // MARK: - Views
    func setupViews() {
        guard let exam = self.example else {
            return
        }
        let _ = exam.configTableView(tableView: self.tableView)
    }
    
    func setupConstraints() {
        
    }
    
    // MARK: - Lazy
}

