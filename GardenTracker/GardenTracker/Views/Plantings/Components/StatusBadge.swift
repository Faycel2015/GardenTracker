//
//  StatusBadge.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct StatusBadge: View {
    let status: PlantingStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical,
                    4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .planned:
            return .gray
        case .active:
            return .green
        case .harvested:
            return .orange
        case .failed:
            return .red
        case .removed:
            return .purple
        }
    }
}

#Preview {
    StatusBadge(status: .active)
}
