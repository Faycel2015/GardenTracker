//
//  ThemeExtensions.swift
//  GardenTracker
//
//  Created by FayTek on 3/13/25.
//

import SwiftUI

// MARK: - Theme Style Modifiers

extension ThemeManager {
    // Default text styles
    var titleStyle: some ViewModifier {
        TitleModifier()
    }
    
    var headlineStyle: some ViewModifier {
        HeadlineModifier()
    }
    
    var bodyStyle: some ViewModifier {
        BodyModifier()
    }
    
    var captionStyle: some ViewModifier {
        CaptionModifier()
    }
    
    // Card appearance
    var cardStyle: some ViewModifier {
        CardModifier()
    }
    
    // Button styles
    var primaryButtonStyle: some ViewModifier {
        PrimaryButtonModifier()
    }
    
    var secondaryButtonStyle: some ViewModifier {
        SecondaryButtonModifier()
    }
}

// MARK: - Modifier Implementations

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(AppColors.textPrimary)
    }
}

struct HeadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(AppColors.textPrimary)
    }
}

struct BodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(AppColors.textPrimary)
    }
}

struct CaptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(AppColors.textSecondary)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppColors.primary)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppColors.secondary)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// MARK: - View Extensions for Easy Access

extension View {
    func titleStyle() -> some View {
        self.modifier(ThemeManager.shared.titleStyle)
    }
    
    func headlineStyle() -> some View {
        self.modifier(ThemeManager.shared.headlineStyle)
    }
    
    func bodyStyle() -> some View {
        self.modifier(ThemeManager.shared.bodyStyle)
    }
    
    func captionStyle() -> some View {
        self.modifier(ThemeManager.shared.captionStyle)
    }
    
    func cardStyle() -> some View {
        self.modifier(ThemeManager.shared.cardStyle)
    }
    
    func primaryButtonStyle() -> some View {
        self.modifier(ThemeManager.shared.primaryButtonStyle)
    }
    
    func secondaryButtonStyle() -> some View {
        self.modifier(ThemeManager.shared.secondaryButtonStyle)
    }
}
