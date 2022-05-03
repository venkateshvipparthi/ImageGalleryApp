//
//  MockNetworkManager.swift
//  ImageGalleryApplicationTests
//
//  Created by Admin on 03/05/2022.
//

import Foundation
@testable import ImageGalleryApplication
import Combine

class MockNetworkManager: Networkble {
    func doApiCall(apiRequest: Requestable) -> Future<[ImageDetail], ServiceError> {

        return Future { promise in
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.path, withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(ServiceError.dataNotFound))
          
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(ImageEntity.self, from: data) else {
                return promise(.failure(ServiceError.parsingError))
            }
            
           let phototsDetails = decodedResponse.photos.photo.map {
               ImageDetail( title: $0.title, url: "\(APIURLs.imagesBaseUrl)/\($0.server)/\($0.id)_\($0.secret)_w.jpg")
            }
        
            return promise(.success(phototsDetails))
        }
    }

}

