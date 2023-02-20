//  Tella
//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import Foundation
import Combine

struct ServerRepository: WebRepository {
    
    func login(username: String,
               password: String,
               serverURL: String) -> AnyPublisher<LoginResult, APIError> {
        
        let call : AnyPublisher<LoginResult, APIError> = call(endpoint: API.login((username: username, password: password, serverURL: serverURL)))
        
        return call
            .eraseToAnyPublisher()
    }
    
    func getProjetDetails(projectURL: String,token: String) -> AnyPublisher<ProjectAPI, APIError> {
        
        let call : AnyPublisher<ProjectDetailsResult, APIError> = call(endpoint: API.getProjetDetails((projectURL: projectURL, token: token)))
        
        return call
            .compactMap{$0.toDomain() as? ProjectAPI }
            .eraseToAnyPublisher()
    }
}

extension ServerRepository {
    enum API {
        case login((username: String,
                    password: String,
                    serverURL: String))
        
        case getProjetDetails((projectURL:String, token: String))
    }
}

extension ServerRepository.API: APIRequest {
    
    var token: String? {
        switch self {
        case .login:
            return nil
        case .getProjetDetails((_, let token)):
            return token
        }
    }
    
    var keyValues: [Key : Value?]? {
        
        switch self {
        case .login((let username, let password, _ )):
            return [
                "username": username,
                "password": password]
        case .getProjetDetails(_):
            return nil
        }
    }
    
    var baseURL: String {
        switch self {
        case .login((_, _, let serverURL)):
            return serverURL
        case .getProjetDetails((let projectURL, _)):
            return projectURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .getProjetDetails(_):
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return HTTPMethod.post
            
        case .getProjetDetails(_):
            return HTTPMethod.get
        }
    }
}
