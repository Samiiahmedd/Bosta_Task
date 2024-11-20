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
        self.title =  albumTitle ?? "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search in images.."
        
        searchController.searchBar.textDidChangePublisher
               .sink { [weak self] searchText in
                   self?.viewModel.updateSearchQuery(searchText)
               }
               .store(in: &cancellables)

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
        return viewModel.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCollectionViewCell.identifier, for: indexPath) as! imagesCollectionViewCell
        let image = viewModel.filteredImages[indexPath.row]
        cell.setupCell(images: image)
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
    
    //MARK: - COLLECTION VIEW INTERACTIONS
       
       func bindCollectionViewInteractions() {
           imagesCollectionView.didSelectItemPublisher
               .sink { [weak self] indexPath in
                   guard let self = self else { return }
                   let selectedImage = self.viewModel.filteredImages[indexPath.row]
                   // BOUNUS : - NANIGATE TO SELECTED IMAGE (ZOOM AND SHARING )
               }
               .store(in: &cancellables)
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
        viewModel.$filteredImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.imagesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}
