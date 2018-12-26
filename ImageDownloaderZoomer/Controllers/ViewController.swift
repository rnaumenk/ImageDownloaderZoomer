//
//  ViewController.swift
//  ImageDownloaderZoomer
//
//  Created by Ruslan on 12/10/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imageView : UIImageView?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.contentSize.width = (imageView?.frame.size.width)!
        scrollView.contentSize.height = scrollView.subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? scrollView.contentSize.height
        scrollView.maximumZoomScale = 100
        scrollView.minimumZoomScale = UIScreen.main.bounds.width / (imageView?.frame.size.width)!
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
