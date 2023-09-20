//
//  CustomFont.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/25/23.
//

import Foundation
import SwiftUI

let titleFont = "Corben-Bold"
let titleFontNormal = "Corben-Regular"
let bodyFont = "Rubik-Light_Regular"

extension Font {
    static let customLargeTitle = Font.custom(bodyFont, size: Font.TextStyle.largeTitle.size, relativeTo: .caption)
    
    static let customTitle = Font.custom(bodyFont, size: Font.TextStyle.title2.size, relativeTo: .caption)
    
    static let customSmall = Font.custom(bodyFont, size: Font.TextStyle.title3.size, relativeTo: .caption)
    
    static let customBody = Font.custom(bodyFont, size: Font.TextStyle.title3.size, relativeTo: .caption)
    
    static let customCaption = Font.custom(bodyFont, size: 25, relativeTo: .caption)
    
    static let customHeadline = Font.custom(bodyFont, size: Font.TextStyle.headline.size, relativeTo: .caption)
//    static let mediumSmallFont = Font.custom(titleFont, size: Font.TextStyle.footnote.size, relativeTo: .caption)
//    static let smallFont = Font.custom(titleFont, size: Font.TextStyle.caption.size, relativeTo: .caption)
//    static let verySmallFont = Font.custom(titleFont, size: Font.TextStyle.caption2.size, relativeTo: .caption)
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 30
        case .headline, .body: return 20
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption: return 12
        case .caption2: return 10
        @unknown default:
            return 8
        }
    }
}
