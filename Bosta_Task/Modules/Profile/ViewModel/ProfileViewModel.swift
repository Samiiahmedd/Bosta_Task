//
//  ProfileViewModel.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation
import Combine
import Moya

class ProfileViewModel {
    
    // MARK: - PROPERITES
    
    @Published var user: User?
    @Published var albums: [AlbumsModel] = []
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var errorMessage: CurrentValueSubject<String?, Never> = .init(nil)
    
    // MARK: - DEPENDANCIES
    
    private var userService: UserServicesProtocol
    private var albumsService : AlbumsServicesProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    
    init(userService: UserServicesProtocol = UserService(), albumsService: AlbumsServicesProtocol = AlbumsServices()) {
        self.userService = userService
        self.albumsService = albumsService
    }
    
    // MARK: - FETCH USER
    
    func fetchUser(by id: Int) {
        isLoading.send(true)
        errorMessage.send(nil)
        
        userService.getUser(by: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading.send(false)
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }
    
    // MARK: - FETCH ALBUMS
    
    func fetchAlbums(by userId: Int) {
        isLoading.send(true)
        errorMessage.send(nil)
        
        albumsService.getAlbums(by: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading.send(false)
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error)
                }
            }, receiveValue: { [weak self] albums in
                self?.albums = albums
            })
            .store(in: &cancellables)
    }
    
    // MARK: - ERROR HANDLING
    
    private func handleError(_ error: Error) {
        errorMessage.send(error.localizedDescription)
    }
}
