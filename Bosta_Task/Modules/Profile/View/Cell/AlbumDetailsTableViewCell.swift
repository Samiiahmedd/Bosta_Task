//
//  AlbumDetailsTableViewCell.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit

class AlbumDetailsTableViewCell: UITableViewCell {
    
    //MARK: - PROPIRITES
    
    static let identifier = "AlbumDetailsTableViewCell"

    //MARK: - IBOUTLETS
    
    @IBOutlet weak var albumNameLabel: UILabel!
}

//MARK: - EXTENSIONS

extension AlbumDetailsTableViewCell {
    
    //MARK: - SETUP CELL

    func Setup(album: AlbumsModel) {
        albumNameLabel.text = album.title
    }
}
