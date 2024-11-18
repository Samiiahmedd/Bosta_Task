//
//  ProfileViewController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var albumsLabel: UILabel!
    @IBOutlet weak var albumsTableView: UITableView!
    
    //MARK: - VARIABLES
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBACTIONS

    
    //MARK: - FUNCTIONS
    
}

//MARK: - EXTENSIONS

extension ProfileViewController {
    
    //MARK: - SETUP VIEW
    
    func setupView() {
        setupNavigationTitle()
    }
    
    func setupNavigationTitle() {
        self.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
