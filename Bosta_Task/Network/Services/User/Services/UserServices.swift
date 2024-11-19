//
//  UserServices.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation
import Moya
import Combine

//MARK: - PROTOCOL

protocol UserServicesProtocol {
    func getUser(by id: Int) -> AnyPublisher<User?, Moya.MoyaError>
}

struct UserService: UserServicesProtocol {
    
    // MARK: - VARIABLES
    
    private let provider = MoyaProvider<UserEndPoint>()
    
    // MARK: - GET USER
    
    func getUser(by id: Int) -> AnyPublisher<User?, MoyaError> {
        provider.requestPublisher(.getUser(id: id))
            .map(\.data)
            .decode(type: User?.self, decoder: JSONDecoder())
            .mapError { moyaError in
                moyaError as? MoyaError ?? MoyaError.underlying(moyaError, nil)
            }
            .eraseToAnyPublisher()
    }
}

