//
//  AppDelegate.swift
//  MovieList
//
//  Created by Vivatum on 15/05/2020.
//  Copyright © 2020 com.vivatum. All rights reserved.
//

import UIKit
import CocoaLumberjack


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var fileLogger: DDFileLogger!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        configureCocoaLumberjack()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


    // MARK: - CocoaLumberjack config
    
    private final func configureCocoaLumberjack() {
        
        setenv("XcodeColors", "YES", 0)
        
        let ddttyLogger = DDTTYLogger.sharedInstance
        ddttyLogger?.logFormatter = LogFormatter()
        DDLog.add(ddttyLogger!)
        
        self.fileLogger = DDFileLogger()
        
        self.fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        self.fileLogger.maximumFileSize = 512 * 512
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 3
        self.fileLogger.logFormatter = LogFormatter()
        
        DDLogInfo("Log framework configured successfully.")
    }

}

