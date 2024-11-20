//
//  ImagesServices.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation
import Moya
import Combine

//MARK: - PROTOCOL

protocol ImagesServicesProtocol {
    func getAlbums(by albumId: Int) -> AnyPublisher<[ImagesModel], MoyaError>
}

struct ImagesServices:ImagesServicesProtocol {
    
    // MARK: - PROPERITES
    
    private let provider = MoyaProvider<ImagesEndPoint>()
    
    // MARK: - GET IMAGES
    
    func getAlbums(by albumId: Int) -> AnyPublisher<[ImagesModel], Moya.MoyaError> {
        provider.requestPublisher(.getImages(albumId: albumId))
            .map(\.data)
            .decode(type: [ImagesModel].self, decoder: JSONDecoder())
            .mapError { moyaError in
                moyaError as? MoyaError ?? MoyaError.underlying(moyaError, nil)
            }
            .eraseToAnyPublisher()
    }
}

