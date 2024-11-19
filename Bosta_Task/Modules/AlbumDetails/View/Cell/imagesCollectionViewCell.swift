//
//  imagesCollectionViewCell.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import UIKit
import Kingfisher

class imagesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - VARIABLES
    
    static let identifier = String(describing: imagesCollectionViewCell.self)
}

//MARK: - EXTENSIONS

extension imagesCollectionViewCell {
    
    //MARK: - SETUP CELL

    func setupCell(images: ImagesModel) {
        let imageUrl = images.url.asUrl
        imageView.kf.setImage(with: imageUrl)
    }
}
