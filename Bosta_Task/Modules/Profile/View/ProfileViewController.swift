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
        getProfile()
        bindViewModel()
    }
    
    //MARK: - FUNCTIONS
    
    private func getProfile() {
        viewModel.fetchUser(by: 1)
        viewModel.fetchAlbums(by: 1)
    }
}

//MARK: - EXTENSIONS

private extension ProfileViewController {
    
    //MARK: - SETUP VIEW
    
    func setupView() {
        setupTableView()
        registerCells()
        setupNavigationTitle()
    }
    
    func setupTableView() {
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
    }
    
    func registerCells() {
        albumsTableView.register(
            UINib(nibName: AlbumDetailsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: AlbumDetailsTableViewCell.identifier
        )
    }
    
    func setupNavigationTitle() {
        self.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

//MARK: - TABLE VIEW

extension ProfileViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTableView.dequeueReusableCell(
            withIdentifier: AlbumDetailsTableViewCell.identifier,
            for: indexPath
        ) as! AlbumDetailsTableViewCell
        cell.Setup(album:viewModel.albums[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = viewModel.albums[indexPath.row]
        let detailVC = AlbumDetailsViewController()
        let detailViewModel = AlbumsDetailsViewModel()
        detailVC.albumTitle = selectedAlbum.title
        detailVC.viewModel = detailViewModel
        detailViewModel.fetchImages(by: selectedAlbum.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

private extension ProfileViewController {
    
    //MARK: - BIND VIEW MODEL
    
    func bindViewModel() {
        bindIsLoading()
        bindErrorState()
        bindUserData()
        bindAlbums()
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
            guard let self = self,  let _ = errorMessage else { return }
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
    
    func bindAlbums() {
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                guard let self = self else { return }
                self.albumsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

