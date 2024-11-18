//
//  AlbumDetailsViewController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    //MARK: - VARIABLES
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBACTIONS
    
    
    
}

//MARK: - EXTENSIONS

extension AlbumDetailsViewController {
    
    //MARK: - SETUP VIEW
    
    func setupView() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        //Set Navigation Title
        self.title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Set SearchBar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in images.."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}
