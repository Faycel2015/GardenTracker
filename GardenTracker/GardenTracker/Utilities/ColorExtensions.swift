//
//  ColorExtensions.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

extension Color {
    // MARK: - Hex Initializer
    
    /// Initialize a Color with a hex string (e.g., "#FF0000" for red)
    /// - Parameter hex: The hex string (can start with or without "#")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: - RGB Initializer
    
    /// Initialize a Color with RGB values (0-255)
    /// - Parameters:
    ///   - r: Red value (0-255)
    ///   - g: Green value (0-255)
    ///   - b: Blue value (0-255)
    ///   - a: Alpha value (0-255), defaults to 255
    init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: - Color Modification
    
    /// Lighten a color by a percentage
    /// - Parameter percentage: The percentage to lighten (0-100)
    /// - Returns: The lightened color
    func lighter(by percentage: CGFloat = 20) -> Color {
        let white = Color.white
        return Color(UIColor.blend(color1: UIColor(self), intensity1: 1.0 - percentage/100,
                                  color2: UIColor(white), intensity2: percentage/100))
    }
    
    /// Darken a color by a percentage
    /// - Parameter percentage: The percentage to darken (0-100)
    /// - Returns: The darkened color
    func darker(by percentage: CGFloat = 20) -> Color {
        let black = Color.black
        return Color(UIColor.blend(color1: UIColor(self), intensity1: 1.0 - percentage/100,
                                  color2: UIColor(black), intensity2: percentage/100))
    }
    
    // MARK: - Garden Theme Colors
    
    // App specific named colors
    static let plantLeafGreen = Color("leafGreen")
    static let plantStemGreen = Color("stemGreen")
    static let tomatoRed = Color("tomatoRed")
    static let carrotOrange = Color("carrotOrange")
    static let pepperYellow = Color("pepperYellow")
    static let eggplantPurple = Color("eggplantPurple")
    static let cucumberGreen = Color("cucumberGreen")
    static let richSoil = Color("richSoil")
    static let gardenwoodBrown = Color("woodBrown")
    
    // MARK: - Gradient Generators
    
    /// Create a soil gradient for garden bed backgrounds
    /// - Returns: A LinearGradient representing soil
    static func soilGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                Color.richSoil,
                Color.richSoil.darker(by: 10)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Create a sky gradient for backgrounds
    /// - Returns: A LinearGradient representing sky
    static func skyGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.lighter(by: 30),
                Color.blue.lighter(by: 60)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Scheme Extensions

extension ColorScheme {
    /// Get the complementary color scheme
    var complement: ColorScheme {
        self == .dark ? .light : .dark
    }
}

// MARK: - UI Color Extensions

extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat, color2: UIColor, intensity2: CGFloat) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2 }
        guard l2 > 0 else { return color1 }
        
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2,
                      green: l1*g1 + l2*g2,
                       blue: l1*b1 + l2*b2,
                      alpha: l1*a1 + l2*a2)
    }
}
