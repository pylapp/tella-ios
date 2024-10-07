//  Tella
//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import SwiftUI
import Combine

class ServersViewModel: ObservableObject {
    
    var mainAppModel : MainAppModel
    
    @Published var currentServer : Server?
    @Published var serverArray : [Server] = []
    @Published var unavailableServers: [Server] = []
    @Published var shouldEnableNextButton: Bool = false
    @Published var selectedServerType: ServerConnectionType?

    private var subscribers = Set<AnyCancellable>()
    
    init(mainAppModel : MainAppModel) {
        
        self.mainAppModel = mainAppModel
        
        self.getServers()
        
        mainAppModel.tellaData?.shouldReloadServers.sink { completion in
        } receiveValue: { shouldReload in
            if shouldReload {
                self.getServers()
            }
        }.store(in: &subscribers)
    }
    
    func getServers() {
        let serverArray = mainAppModel.tellaData?.getServers() ?? []
        self.serverArray = serverArray
        self.unavailableServers = serverArray.filter { $0.allowMultiple == false }
    }
    
    func deleteServer() {
        guard let server = self.currentServer else { return }
        
        mainAppModel.tellaData?.deleteServer(server: server)
    }
    
    func deleteAllServersConnection() {
        mainAppModel.tellaData?.deleteAllServers()
    }
    
    func filterServerConnections() -> [ServerConnectionButton] {
        let unavailableTypes = Set(unavailableServers.compactMap { $0.serverType })
        
        return serverConnections.filter { connection in
            !unavailableTypes.contains(connection.type)
        }
    }}
