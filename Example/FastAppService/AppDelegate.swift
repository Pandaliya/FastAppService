//
//  AppDelegate.swift
//  FastAppService
//
//  Created by zhangpan on 07/15/2022.
//  Copyright (c) 2022 zhangpan. All rights reserved.
//

import UIKit
import CoreData
import FastAppService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.launchWidow()
        
        if #available(iOS 13.0, *) {
            FastCoreData.shared.autoMergeChange(container: self.persistentContainer)
        } else {
            
        }
        
        return true
    }
    
    func launchWidow() {
        if self.window == nil {
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        let navi = UINavigationController.init(rootViewController: CaseListController.init(style: .plain))
        AC.rootController = navi
        self.window?.rootViewController = navi
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data
    @available(iOS 13.0, *)
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "FastCloud")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber,
                                       forKey: NSPersistentHistoryTrackingKey)
        
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description?.setOption(true as NSNumber, forKey: remoteChangeKey)
        
        return container
    }()
    
    private func testfunc() {
//        NSPersistentContainer
//        NSPersistentStoreCoordinator
//        NSPersistentStoreDescription
//        NSPersistentCloudKitContainerOptions
//        container.persistentStoreDescriptions
    }

}

