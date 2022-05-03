//
//  ViewState.swift
//  ImageGalleryApplication
//
//  Created by Admin on 03/05/2022.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
