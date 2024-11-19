//
//  AlbumsDetailsViewModel.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation
import Combine
import Moya

class AlbumsDetailsViewModel {
    
    // MARK: - PROPERITES
    
    @Published var images: [ImagesModel] = []
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var errorMessage: CurrentValueSubject<String?, Never> = .init(nil)
    
    // MARK: - DEPENDANCIES
    
    private var imagesServices: ImagesServicesProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    
    init(imagesServices: ImagesServicesProtocol = ImagesServices()) {
        self.imagesServices = imagesServices
    }
    
    // MARK: - FETCH IMAGES
    
    func fetchImages(by albumId: Int) {
        isLoading.send(true)
        errorMessage.send(nil)
        
        imagesServices.getAlbums(by: albumId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading.send(false)
                switch completionResult {
                case .finished:
                    print("Finished fetching images.")
                case .failure(let error):
                    self.errorMessage.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] images in
                self?.images = images
            })
            .store(in: &cancellables)
    }
}

