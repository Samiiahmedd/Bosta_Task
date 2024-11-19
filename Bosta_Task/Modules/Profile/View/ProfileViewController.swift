//
//  ProfileViewController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit
import Combine
import CombineCocoa

class ProfileViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var suiteLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var albumsLabel: UILabel!
    @IBOutlet weak var albumsTableView: UITableView!
    
    // MARK: - PROPERITES
    
    private let viewModel = ProfileViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchUser()
        bindViewModel()
    }
    
    //MARK: - FUNCTIONS
    
    private func fetchUser() {
        viewModel.fetchUser(by: 1)
    }
}

//MARK: - EXTENSIONS

private extension ProfileViewController {
    
    //MARK: - SETUP VIEW
    
    func setupView() {
        setupNavigationTitle()
    }
    
    func setupNavigationTitle() {
        self.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension ProfileViewController {
    
    //MARK: - BIND VIEW MODEL
    
    func bindViewModel() {
        bindIsLoading()
        bindErrorState()
        bindUserData()
    }
    
    func bindIsLoading() {
        viewModel.isLoading.sink { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                self.showLoader()
            } else {
                self.hideLoader()
            }
        }.store(in: &cancellables)
    }
    
    func bindErrorState() {
        viewModel.errorMessage.sink { [weak self] errorMessage in
            guard let self = self, let errorMessage = errorMessage else { return }
            AlertManager.showAlert(on: self, title: "Error", message: "Something went wrong")
        }.store(in: &cancellables)
    }
    
    func bindUserData() {
        viewModel.$user
            .sink { [weak self] user in
                guard let self = self, let user = user else { return }
                self.nameLabel.text = "\(user.name),"
                self.streetLabel.text = "\(user.address.street),"
                self.suiteLabel.text = "\(user.address.suite),"
                self.cityLabel.text = "\(user.address.city),"
                self.zipCodeLabel.text = (user.address.zipcode)
            }
            .store(in: &cancellables)
    }
}

