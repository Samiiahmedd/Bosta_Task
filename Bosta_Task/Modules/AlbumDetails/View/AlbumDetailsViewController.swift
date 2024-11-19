//
//  AlbumDetailsViewController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit
import Combine
import CombineCocoa

class AlbumDetailsViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: - PROPERITES
    
    var albumTitle: String?
    var viewModel = AlbumsDetailsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

//MARK: - EXTENSIONS

extension AlbumDetailsViewController {
    
    //MARK: - SETUP VIEW
    
    func setupView() {
        setupNavigationBar()
        setupCollectionView()
        registerCell()
        bindViewModel()
    }
    
    func setupNavigationBar() {
        //Set Navigation Title
        self.title =  albumTitle ?? "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Set SearchBar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in images.."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    func registerCell() {
        imagesCollectionView.register(UINib(nibName: imagesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: imagesCollectionViewCell.identifier)
    }
}

//MARK: - COLLECTION VIEW

extension AlbumDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCollectionViewCell.identifier, for: indexPath) as! imagesCollectionViewCell
        let images = viewModel.images[indexPath.row]
        cell.setupCell(images: images)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let availableWidth = collectionView.bounds.width
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
}



//MARK: - VIEW MODEL

private extension AlbumDetailsViewController {
    
    //MARK: - BIND VIEW MODEL
    
    func bindViewModel() {
        bindIsLoading()
        bindErrorState()
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
    
    func bindAlbums() {
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                guard let self = self else { return }
                self.imagesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
}
