//
//  NetworkObserver.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import Foundation
import Network
import Combine

@MainActor
final class NetworkObserver: ObservableObject {
    public static let shared: NetworkObserver = .init()
    
    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var isExpensive: Bool = false
    @Published public private(set) var isLowDataModeEnabled: Bool = false
    public var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }
    public var isExpensivePublisher: Published<Bool>.Publisher { $isExpensive }
    public var isLowDataModeEnabledPublisher: Published<Bool>.Publisher { $isLowDataModeEnabled }
    
    private let monitor: NWPathMonitor = .init()
    private let queue: DispatchQueue = .init(label: "NetworkMonitor")
    
    deinit {
        Task { [weak self] in
            guard let self = self else { return }
            await self.stopMonitor()
        }
    }
    
    private init() {
        Task {  await self.startMonitoring() }
    }
    
    private func startMonitoring() async {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            Task { await self.changeConnectionStatus(with: path)}
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitor() async {
        monitor.cancel()
    }
    
    private func changeConnectionStatus(with path: NWPath) async {
        self.isConnected = path.status == .satisfied
        self.isExpensive = path.isExpensive
        self.isLowDataModeEnabled = path.isConstrained
    }
}
