//
//  String+Extension.swift
//  MBCommon
//
//  Created by Zhenis Mutan on 10/27/20.
//

import Foundation
import UIKit

#if os(iOS) || os(tvOS)
import UIKit
public typealias UniColor = UIColor
#else
import Cocoa
public typealias UniColor = NSColor
#endif

private extension Int {
    func duplicate4bits() -> Int {
        (self << 4) + self
    }
}

public extension UniColor {
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }

    private convenience init?(hex3: Int, alpha: Float) {
        self.init(red: CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue: CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red: CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue: CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }

    convenience init?(hexString: String, alpha: Float) {
        var hex = hexString

        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
                self.init()
                return nil
        }
    }

    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}

public extension String {
    func toColor() -> UniColor? {
        UniColor(hexString: self)
    }
}

public extension Int {
    func toColor(alpha: Float = 1.0) -> UniColor? {
        UniColor(hex: self, alpha: alpha)
    }
}

