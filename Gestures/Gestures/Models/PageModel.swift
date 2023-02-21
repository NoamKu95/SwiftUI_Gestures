//
//  PageModel.swift
//  Gestures
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
