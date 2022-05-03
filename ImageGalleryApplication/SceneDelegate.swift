//
//  SceneDelegate.swift
//  ImageGalleryApplication
//
//  Created by Admin on 02/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
          
          guard let sceneWindow = (scene as? UIWindowScene) else { return }
          
          let navController = UINavigationController()
          coordinator = MainCoordinator(navigationController: navController)
          
          //control with cordinator
          coordinator?.start()
          window = UIWindow(windowScene: sceneWindow)
          window?.rootViewController = navController
          window?.makeKeyAndVisible()
        
    }

}

