//
//  AppManager.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation
import Alamofire

class AppManager: NSObject {
    static let G_APP_NAME = "SearchMovies"
    let webServiceManager = WebServicesManager()
    
    //MARK: - Singleton of Manager
    private static var shareManager: AppManager = {
        let manager = AppManager()
        return manager
    }()
    class func shared() -> AppManager {
        return shareManager
    }
    
    
    //MARK: - Networking Tasks
    private var _isNetworkConnection: Bool = false
    var isNetworkConnection: Bool {
        get{
            if _isNetworkConnection == false {
                AppManager.displayOkayAlert(title: AppManager.G_APP_NAME,
                                            message: Network_Error.G_NO_NETWORK_CONNECTION,
                                            forController: nil)
            }
            return _isNetworkConnection
        }
        set{
            _isNetworkConnection = newValue
            if newValue == false {
                AppManager.displayOkayAlert(title: AppManager.G_APP_NAME,
                                            message: Network_Error.G_NO_NETWORK_CONNECTION,
                                            forController: nil)
            }
        }
    }
    
    func startNetworkReachabilityObserver() {
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = { status in
            if net?.isReachable ?? false {
                if net?.isReachableOnEthernetOrWiFi != nil && net?.isReachableOnEthernetOrWiFi == true {
                    #if DEBUG
                    print("[Debug] - Reachable on Wifi")
                    #endif
                    self.isNetworkConnection = true
                } else if (net?.isReachableOnWWAN)! {
                    #if DEBUG
                    print("[Debug] - Reachable on WWAN")
                    #endif
                    self.isNetworkConnection = true
                }
            } else {
                #if DEBUG
                print("[Debug] - no connection")
                #endif
                self.isNetworkConnection = false
            }
        }
    }
    class func formatDate(_ dateString : String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        
        return String(Calendar.current.component(.year, from: date))
    }
    
    class func displayOkayAlert(title:String, message:String, forController controller:UIViewController?, okayHandler:((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: UIAlertAction.Style.default,
                                      handler: okayHandler))
        
        DispatchQueue.main.async(execute: {
            if let VC = controller {
                VC.present(alert, animated: true, completion: nil)
                
            } else {
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    rootVC.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
extension AppManager {
    class func posterUrlFor(size : ImageSize, poster : String) -> URL? {
        guard poster != "" else { return nil}
        let urlString = "\(imagesBaseUrl)\(size.rawValue)\(poster)"
        return URL(string: urlString)
    }
}

enum ImageSize : String {
    case width92 = "w92"
    case width185 = "w185"
    case width500 = "w500"
    case width780 = "w780"
}

struct Network_Error {
    static let G_NO_NETWORK_CONNECTION = "No Network Connection"
}
