//
//  ProfileViewModel.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation
import Combine
import Moya

class ProfileViewModel:ObservableObject {
    
    // MARK: - PROPERITES
    
    @Published var user: User?
    var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var errorMessage: CurrentValueSubject<String?, Never> = .init(nil)
    
    // MARK: - DEPENDANCIES
    
    private var userService: UserServicesProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    
    init(userService: UserServicesProtocol = UserService()) {
        self.userService = userService
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
                    self.errorMessage.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] user in
                self?.user = user
            })
            .store(in: &cancellables)
    }
}
