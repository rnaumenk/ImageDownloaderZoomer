//
//  CollectionVC.swift
//  ImageDownloaderZoomer
//
//  Created by Ruslan on 12/10/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "cell"
    private let failImageName = "fail"
    private let dispatchGroup = DispatchGroup()
    private var loadedImages: [UIImage?] = {
        var array = [UIImage?]()
        
        for _ in 0 ..< MyData.url.count {
            array.append(UIImage())
        }
        
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSettings(with: UIScreen.main.bounds.width - 80)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for i in 0 ..< MyData.url.count {
            dispatchGroup.enter()
            self.loadImages(i)
        }
        dispatchGroup.notify(queue: .main) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionViewSettings(with: size.width - 80)
    }
    
    private func collectionViewSettings(with itemSize: CGFloat) {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 20
        
        collectionView.collectionViewLayout = layout
    }
    
    private func loadImages(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        let url = URL(string: MyData.url[index])
        
        cell.activityIndicator.hidesWhenStopped = true
        cell.activityIndicator.startAnimating()
        
        guard url != nil else {
            loadedImages[index] = UIImage(named: self.failImageName)
            self.collectionView.reloadItems(at: [indexPath])
            cell.activityIndicator.stopAnimating()
            dispatchGroup.leave()
            showAlertController("Address does not conform to URL")
            return
            
        }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    self.loadedImages[index] = image
                }
                else {
                    self.loadedImages[index] = UIImage(named: self.failImageName)
                    self.showAlertController("Data is not an image")
                }
            }
            else {
                self.loadedImages[index] = UIImage(named: self.failImageName)
                self.showAlertController("Wrong URL")
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [indexPath])
                cell.activityIndicator.stopAnimating()
            }
            
            self.dispatchGroup.leave()
        }
    }
    
}

extension CollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyData.url.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        
        cell.imageView.image = loadedImages[indexPath.row]
        cell.activityIndicator.startAnimating()
        
        return cell
    }
    
}

extension CollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let zoomVC = storyboard?.instantiateViewController(withIdentifier: "ZoomVCid") as! ZoomVC
        zoomVC.image = loadedImages[indexPath.row]
        show(zoomVC, sender: self)
    }
}

extension UIViewController {
    func showAlertController(_ message: String, _ title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

