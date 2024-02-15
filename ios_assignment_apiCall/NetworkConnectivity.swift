//
//  NetworkConnectivity.swift
//  ios_assignment_apiCall
//
//  Created by promact on 14/02/24.
//

import Network
import Foundation

class NetworkConnectivity {
    static func internetConnectivity(completion: @escaping(Bool) -> Void){
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
//                print("Internet connection is available")
            } else {
//                print("No internet connection")
            }
            let isConnected = (path.status == .satisfied)
            
            let _ = completion(isConnected)
            print(isConnected)
        }
    }
}
