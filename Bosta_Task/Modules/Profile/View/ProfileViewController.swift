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
        bindTableViewInteractions()
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
        setupTableViewHeader()
    }
    
    func setupTableView() {
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
    }
    
    func registerCells() {
        albumsTableView.register(
            UINib(nibName: ProfileConstants.cellNibName, bundle: nil),
            forCellReuseIdentifier: ProfileConstants.cellReuseIdentifier
        )
    }
    
    func setupNavigationTitle() {
        self.title = ProfileConstants.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupTableViewHeader() {
        let headerView = UIView()
        headerView.backgroundColor = ProfileConstants.headerBackgroundColor
        
        let titleLabel = UILabel()
        titleLabel.text = ProfileConstants.headerTitle
        titleLabel.font = ProfileConstants.headerFont
        titleLabel.textColor = ProfileConstants.headerTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 2),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        albumsTableView.tableHeaderView = headerView
        albumsTableView.tableHeaderView?.frame.size.height = ProfileConstants.headerHeight
    }
}

//MARK: - TABLE VIEW

extension ProfileViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTableView.dequeueReusableCell(
            withIdentifier: ProfileConstants.cellReuseIdentifier,
            for: indexPath
        ) as! AlbumDetailsTableViewCell
        cell.selectionStyle = ProfileConstants.cellSelectionStyle
        cell.Setup(album: viewModel.albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProfileConstants.tableRowHeight
    }
    
    //MARK: - TABLE VIEW INTERACTIONS
    
    func bindTableViewInteractions() {
        albumsTableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                let selectedAlbum = self.viewModel.albums[indexPath.row]
                let detailVC = AlbumDetailsViewController()
                let detailViewModel = AlbumsDetailsViewModel()
                detailVC.albumTitle = selectedAlbum.title
                detailVC.viewModel = detailViewModel
                detailViewModel.fetchImages(by: selectedAlbum.id)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            .store(in: &cancellables)
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
                let indexPaths = albums.enumerated().map { IndexPath(row: $0.offset, section: 0) }
                self.albumsTableView.insertRows(at: indexPaths, with: .automatic)
            }
            .store(in: &cancellables)
    }
}

//MARK: - CONSTANTS

fileprivate struct ProfileConstants {
    static let navigationTitle = "Profile"
    static let headerTitle = "My Albums"
    static let headerFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let headerTextColor = UIColor.black
    static let headerBackgroundColor = UIColor.white
    static let headerHeight: CGFloat = 30
    static let tableRowHeight: CGFloat = 50
    static let alertTitle = "Error"
    static let alertMessage = "Something went wrong"
    static let cellNibName = AlbumDetailsTableViewCell.identifier
    static let cellReuseIdentifier = AlbumDetailsTableViewCell.identifier
    static let cellSelectionStyle = UITableViewCell.SelectionStyle.none
}
