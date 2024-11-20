//
//  NetworkManager.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 13/11/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}



