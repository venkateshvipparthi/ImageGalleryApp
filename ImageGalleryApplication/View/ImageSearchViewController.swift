//
//  ViewController.swift
//  ImageGalleryApplication
//
//  Created by Admin on 02/05/2022.
//

import UIKit
import Combine

class ImageSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let pendingOperations = PendingOperations()
    
    private var bindings = Set<AnyCancellable>()
    
    weak var coordinator: MainCoordinator?
        
    
    var viewModel:ImageSearchViewModelType = ImageSearchViewModel(networkManager: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        bindViewModelState()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            self.viewModel.search(request: Request(baseUrl: APIURLs.baseUrl, path:"", params: ["method":APIURLs.photoMethod, "text": "\(text)", "api_key": APIURLs.apiKey, "format" : "json", "nojsoncallback" : "1"]))
            
        }
        
        
    }
    
    private func bindViewModelState() {
        let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            collectionView.isHidden = true
        case .loading:
            collectionView.isHidden = true
        case .finishedLoading:
            collectionView.isHidden = false
            collectionView.reloadData()
            searchBar.resignFirstResponder()
        case .error(_):
            collectionView.reloadData()
            searchBar.resignFirstResponder()

        }
    }

}
extension ImageSearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoDetailsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageDetailCollectionViewCell else {return UICollectionViewCell()}
    
        collectionCell.setData(viewModel.photoDetails[indexPath.row])

        let photoDetails = viewModel.photoRecords[indexPath.row]

        switch (photoDetails.state) {
       
        case .failed:
            collectionCell.imgDesc?.text = "Failed to load"
        case .new :
              startDownload(for: photoDetails, at: indexPath)
          
        case .downloaded :
            collectionCell.imageCollectionCell.image = photoDetails.image
        }
        
        return collectionCell
    }
    
    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
      //1
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      //2
      let downloader = ImageDownLoaderService(photoRecord)
      //3
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
            self.collectionView.reloadItems(at: [indexPath])

        }
      }
      //4
      pendingOperations.downloadsInProgress[indexPath] = downloader
      //5
      pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
extension ImageSearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 1 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:300)
    }
}

