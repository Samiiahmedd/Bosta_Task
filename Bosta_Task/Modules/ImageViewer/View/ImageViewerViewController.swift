//
//  ImageViewerViewController.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 20/11/2024.
//

import UIKit
import Combine
import CombineCocoa

class ImageViewerViewController: UIViewController {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - PROPIRITES
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel = ImageViewerViewModel()
    
    //MARK: - VIWE LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        setupBindings()
    }
    
    //MARK: - FUNCTIONS
    
    func configureScrollView() {
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 4.0
        imageScrollView.zoomScale = 1.0
    }
    
    func setupBindings() {
        viewModel.$selectedImage
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)
        
        viewModel.$zoomScale
            .sink { [weak self] zoomScale in
                self?.imageScrollView.zoomScale = zoomScale
                print("Zoom scale updated: \(zoomScale)")
            }
            .store(in: &cancellables)
        
        shareButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.shareImage()
            }
            .store(in: &cancellables)
        
        viewModel.shareImageSubject
            .sink { [weak self] image in
                self?.presentShareSheet(for: image)
            }
            .store(in: &cancellables)
    }
    
    func presentShareSheet(for image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func selectImage(image: UIImage) {
        viewModel.setSelectedImage(image)
    }
}

//MARK: - EXTENSIONS

extension ImageViewerViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        viewModel.updateZoomScale(scrollView.zoomScale)
    }
}
