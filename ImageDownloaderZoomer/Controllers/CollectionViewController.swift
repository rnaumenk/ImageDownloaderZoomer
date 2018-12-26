//
//  CollectionViewController.swift
//  ImageDownloaderZoomer
//
//  Created by Ruslan on 12/10/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    private var images : [Int:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemSize = UIScreen.main.bounds.width - 80
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumLineSpacing = 20
        
        collectionView?.collectionViewLayout = layout
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.URLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let url = URL(string: Model.URLs[indexPath.row])
        self.spinner(shouldSpin: true, cell: cell)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    
                    cell.imageView.image = UIImage(data: data)
                    self.images[indexPath.row] = cell.imageView.image!
                    self.spinner(shouldSpin: false, cell: cell)
                    if indexPath.row == 3 {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
        
        return cell
    }
    
    private func spinner(shouldSpin status: Bool, cell: CollectionViewCell) {
        if status == true {
            cell.spinner.isHidden = false
            cell.spinner.startAnimating()
        } else {
            cell.spinner.isHidden = true
            cell.spinner.stopAnimating()
        }
    }
    
    private func displayAlert(message: String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        } ))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.image = images[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
