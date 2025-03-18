//
//  WeatherDetailRow.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct WeatherDetailRow: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(AppColors.info)
            
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
            
            Text(label)
                .foregroundColor(.secondary)
                .foregroundColor(AppColors.textSecondary)
        }
        .font(.caption)
    }
}

#Preview {
    WeatherDetailRow(
        icon: "thermometer",
        value: "75°F",
        label: "Current Temperature"
    )
}
