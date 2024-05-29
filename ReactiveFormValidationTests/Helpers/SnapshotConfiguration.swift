//
//  SnapshotConfiguration.swift
//  ReactiveFormValidationTests
//
//  Created by Marcos Amaral on 29/05/24.
//

import UIKit

struct SnapshotConfiguration {
    let size: CGSize
    let traitCollection: UITraitCollection
    
    struct Dimension {
        let width: Int
        let height: Int
    }
    
    enum Device {
        case iPhone15
        case iPhoneSE
        case iPhoneSE1
        case iPhone15ProMax
        
        func getDeviceDimensions() -> Dimension {
            switch self {
            case .iPhone15:
                return Dimension(width: 393, height: 852)
            case .iPhoneSE:
                return Dimension(width: 375, height: 667)
            case .iPhoneSE1:
                return Dimension(width: 320, height: 568)
            case .iPhone15ProMax:
                return Dimension(width: 430, height: 932)
            }
        }
    }
    
    static func iPhone(style: UIUserInterfaceStyle, device: Device = .iPhone15, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        let dimensions = device.getDeviceDimensions()
        
        return SnapshotConfiguration(
            size: CGSize(width: dimensions.width, height: dimensions.height),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.accessibilityContrast = .normal
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            }))
    }
}
