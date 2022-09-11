//
//  ViewController.swift
//  FastAppService
//
//  Created by zhangpan on 07/15/2022.
//  Copyright (c) 2022 zhangpan. All rights reserved.
//

import UIKit
import FastExtension

class CaseListController: ExampleCaseTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "App Service"
        self.fillCase()
    }
    
    func fillCase() {
        let sign = AppleSignCase.init()
        sign.callBack = {[weak self] in
            guard let self = self else { return }
            sign.routerToContoller(from: self)
        }
        
        let coredata = CoreDataCase.init(callBack: nil)
        coredata.callBack = {[weak self] in
            guard let self = self else { return }
            coredata.routerToContoller(from: self)
        }
        
        let cloud = CloudCase.init {
            debugPrint("controller call back")
        }
        
        let location = LocationCase.init {
            debugPrint("controller call back")
        }
        
        let cases:[ExampleCase] = [
            sign,
            coredata,
            cloud,
            location
        ]
        
        let appleServiceSet = AppCaseSet.init(title: "苹果服务", fold: false)
        appleServiceSet.cases.append(contentsOf: cases)
        
        self.testSets = [
            appleServiceSet
        ]
    }
}

