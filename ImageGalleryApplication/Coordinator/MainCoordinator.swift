//
//  MainCoordinator.swift
//  ImageGalleryApplication
//
//  Created by Admin on 03/05/2022.
//

import Foundation

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        
        guard  let vc =  UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier:"ImageSearchViewController") as? ImageSearchViewController else {
            return
        }
        vc.coordinator = self
        vc.viewModel = ImageSearchViewModel(networkManager: NetworkManager())
        navigationController.pushViewController(vc, animated: false)
    }
    
}
