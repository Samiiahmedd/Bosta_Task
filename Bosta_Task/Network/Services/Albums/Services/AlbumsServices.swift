//
//  AlbumsServices.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation
import Moya
import Combine

//MARK: - PROTOCOL

protocol AlbumsServicesProtocol {
    func getAlbums(by userId: Int) -> AnyPublisher<[AlbumsModel], MoyaError>
}

struct AlbumsServices:AlbumsServicesProtocol {
    
    // MARK: - VARIABLES
    
    private let provider = MoyaProvider<AlbumsEndPoint>()
    
    // MARK: - GET ALBUMS
    
    func getAlbums(by userId: Int) -> AnyPublisher<[AlbumsModel], MoyaError> {
        provider.requestPublisher(.getAlbums(userId: userId))
            .map(\.data)
            .decode(type: [AlbumsModel].self, decoder: JSONDecoder())
            .mapError { moyaError in
                moyaError as? MoyaError ?? MoyaError.underlying(moyaError, nil)
            }
            .eraseToAnyPublisher()
    }
    
}
