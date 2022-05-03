//
//  ImageSearchViewModel.swift
//  ImageGalleryApplication
//
//  Created by Admin on 03/05/2022.
//

import Foundation
import Combine


protocol ImageSearchViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    var photoDetailsCount:Int { get }
    var photoDetails:[ImageDetail] { get }
    var photoRecords:[PhotoRecord] { get }

    func search(request: Request)
}

final class ImageSearchViewModel: ImageSearchViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let networkManager:Networkble
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var photoDetails:[ImageDetail] = []
    var photoRecords:[PhotoRecord] = []

    var photoDetailsCount: Int {
        return photoDetails.count
    }
    
    init(networkManager:Networkble) {
        self.networkManager = networkManager
    }
    
    func search(request: Request) {
        
        state = ViewState.loading
        let publisher = networkManager.doApiCall(apiRequest: request)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.photoDetails = []
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] images in
            self?.photoDetails = images
            self?.photoRecords =  images.map {
                PhotoRecord(name: $0.title, url: $0.url)
            }
            self?.state = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
