//
//  AlbumsDetailsViewModel.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import UIKit
import Combine
import Moya

class AlbumsDetailsViewModel {
    
    // MARK: - PROPERITES
    
    @Published var images: [ImagesModel] = []
    @Published var filteredImages: [ImagesModel] = []
    private var searchQueryPublisher: PassthroughSubject<String, Never> = .init()
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var errorMessage: CurrentValueSubject<String?, Never> = .init(nil)
    var selectedImageSubject = PassthroughSubject<UIImage, Never>() 

    
    // MARK: - DEPENDANCIES
    
    private var imagesServices: ImagesServicesProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    
    init(imagesServices: ImagesServicesProtocol = ImagesServices()) {
        self.imagesServices = imagesServices
        
        searchQueryPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.updateSearchQuery(query)
            }
            .store(in: &cancellables)
        
        $images
            .sink { [weak self] images in
                self?.filteredImages = images
            }
            .store(in: &cancellables)
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
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] images in
                self?.images = images
            })
            .store(in: &cancellables)
    }
    
    // MARK: - FETCH FULL-SIZE IMAGE
        
        func fetchFullSizeImage(for imageModel: ImagesModel) {
            guard let imageURL = URL(string: imageModel.url) else {
                print("Invalid image URL")
                return
            }
            
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    print("Failed to fetch image")
                    return
                }
                DispatchQueue.main.async {
                    self?.selectedImageSubject.send(image)
                }
            }.resume()
        }
    
    // MARK: - SEARCH FUNCTIONALITY
    
    func updateSearchQuery(_ query: String) {
        if query.isEmpty {
            filteredImages = images
        } else {
            filteredImages = images.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
    
    // MARK: - ERROR HANDLING
    
    private func handleError(_ error: Error) {
        errorMessage.send(error.localizedDescription)
    }
}

