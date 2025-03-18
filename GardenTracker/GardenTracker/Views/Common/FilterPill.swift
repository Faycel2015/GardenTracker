//
//  FilterPill.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? AppColors.secondary : AppColors.primary)
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    FilterPill(
        title: "Sample Filter",
        isSelected: true,
        action: {}
    )
}
