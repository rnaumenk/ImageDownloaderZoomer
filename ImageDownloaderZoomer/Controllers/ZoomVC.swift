//
//  ViewController.swift
//  ImageDownloaderZoomer
//
//  Created by Ruslan on 12/10/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class ZoomVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView : UIImageView?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.contentSize = (imageView?.frame.size)!
        scrollView.maximumZoomScale = 100
        scrollView.minimumZoomScale = min(view.bounds.height / (imageView?.frame.size.height)!, view.bounds.width / (imageView?.frame.size.width)!)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = min(size.height / (imageView?.frame.size.height)!, size.width / (imageView?.frame.size.width)!)
    }
    
}

extension ZoomVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
