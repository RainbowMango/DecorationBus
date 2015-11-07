//
//  AppDelegate.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 得到当前应用的版本号
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 得到上次启动时的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let lastAppVersion = userDefaults.stringForKey("lastAppVersion")
        
        // 如果lastAppVersion为nil说明是第一次启动；如果lastAppVersion不等于currentAppVersion说明是更新了
        if lastAppVersion == nil || lastAppVersion != currentAppVersion {
            
            //userDefaults.setValue(currentAppVersion, forKey: "lastAppVersion")
            
            // 创建引导页VC
            let item1 = RMParallaxItem(image: UIImage(named: "intr001")!, text: "装修路上处处陷阱...")
            let item2 = RMParallaxItem(image: UIImage(named: "intr002")!, text: "低价往往不是让利促销...")
            let item3 = RMParallaxItem(image: UIImage(named: "intr003")!, text: "设计师的时间总是伴随着利益...")
            let item4 = RMParallaxItem(image: UIImage(named: "intr004")!, text: "装修增项让人防不胜防...")
            let item5 = RMParallaxItem(image: UIImage(named: "intr005")!, text: "我们, 只是想让装修更简单一点点...")
            let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4, item5], motion: false)
            
            //定义结束引导页行为
            rmParallaxViewController.completionHandler = {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewControllerWithIdentifier("rootVC")
                mainViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                
                /*
                    presentViewController展现稍显缓慢，大概需要2s左右，
                    1. 给引导页rmParallaxViewController做个淡出动画，在用户点击关闭按钮时可以立即响应
                    2. rmParallaxViewController背景没有设置全透明，防止出现黑屏
                
                    Note: 在全面支持IOS8.0时再来试下
                */
                rmParallaxViewController.presentViewController(mainViewController, animated: true, completion: nil)
                UIView.animateWithDuration(2, animations: { () -> Void in
                    
                    rmParallaxViewController.view.alpha = 0.2
                })
            }
            

            self.window!.rootViewController = rmParallaxViewController
        }
        
        
        // 集成友盟
        MobClick.startWithAppkey("562b8874e0f55a9afb0005ee", reportPolicy: BATCH, channelId: nil)
        //MobClick.setLogEnabled(true) //只在调试时打开日志
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ruby.DecorationBus" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DecorationBus", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DecorationBus.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [NSObject : AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

