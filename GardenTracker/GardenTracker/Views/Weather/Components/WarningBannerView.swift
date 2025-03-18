//
//  WarningBannerView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct WarningBannerView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.yellow)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.yellow.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    WarningBannerView(message: "Warning: Frost expected tonight!")
}
