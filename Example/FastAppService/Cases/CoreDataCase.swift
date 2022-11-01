//
//  CoreDataCase.swift
//  FAService
//
//  Created by pan zhang on 2022/7/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
// Core Data 和 iCloud常用操作

import Foundation
import UIKit
import CoreData
import FastAppService

class CoreDataCase: NSObject, ExampleCase {
    var title: String = "CoreData & iCloud"
    var callBack: (() -> ())? = nil
    var users: [User] = []
    
    var vc: CaseTableViewController? = nil
    var controller: UIViewController? {
        let controller = CaseTableViewController.init(exam: self, style: .plain)
        controller.navigationItem.title = "CoreData & iCloud"
        self.vc = controller
        return self.vc
    }
    
    convenience init(callBack: (() -> ())?) {
        self.init()
        self.callBack = callBack
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(fetchChanges),
                name: NSNotification.Name(
                    rawValue: "NSPersistentStoreRemoteChangeNotification"),
                object: AC.container?.persistentStoreCoordinator
            )
        } else {
            
        }
    }
    
    @objc func fetchChanges() {
        if #available(iOS 13.0, *), let context = AC.coreDataContext {
            let fetchRequest = NSFetchRequest<User>(entityName:"User")
            do {
                let results: [User] = try context.fetch(fetchRequest)
                self.users.append(contentsOf: results)
            } catch {
                debugPrint("fetch user error: \(error)")
            }
        }
        self.vc?.tableView.reloadData()
    }
    
    func configTableView(tableView: UITableView) -> Bool {
        self.users.removeAll()
        
        self.fetchChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DataCloudCase")
        return true
    }
    
    func caseAction() -> Bool {
        if let callBack = callBack {
            debugPrint("\(type(of: self)) Executing: call back")
            callBack()
        }
        debugPrint("\(type(of: self))  Executing: case action")
        
        self.routerToContoller()
        return true
    }
    
    @available(iOS 13.0, *)
    func docSchema() {
        // Only initialize the schema when building the app with the
        // Debug build configuration.
        #if DEBUG
        do {
            try AC.container?.initializeCloudKitSchema(options: [])
        } catch {
            debugPrint("fetch user error: \(error)")
        }
        #endif
    }
    
}

extension CoreDataCase: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCloudCase", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = " + "
        } else {
            if indexPath.row < self.users.count {
                cell.textLabel?.text = "user: \(self.users[indexPath.row].uid)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if #available(iOS 13.0, *) {
                self.deleteUser()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if indexPath.section == 0 {
                self.addUser()
                return
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func addUser() {
        guard let c = AC.coreDataContext else {
            return
        }
        
        let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: c) as! User
        user.uid = Int64(Date().timeIntervalSince1970)
        do {
            try c.save()
            debugPrint("save user success")
        } catch {
            debugPrint("save user error: \(error)")
        }
        self.users.append(user)
        self.vc?.tableView.reloadData()
    }
    
    @available(iOS 13.0, *)
    private func deleteUser() {
        debugPrint("deleteUser")
    }
}

