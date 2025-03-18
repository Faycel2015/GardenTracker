//
//  PlantingRowView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct PlantingRowView: View {
    let planting: Planting
    
    var body: some View {
        HStack {
            Circle()
                .fill(AppColors.forPlantingStatus(planting.status))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading) {
                Text(planting.plant?.name ?? "Unknown Plant")
                    .font(.headline)
                
                Text("Planted: \(planting.datePlanted.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let harvestDate = planting.expectedHarvestDate {
                    Text("Expected harvest: \(harvestDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text("Qty: \(planting.quantity)")
                .font(.caption)
                .padding(4)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
    
    private var statusColor: Color {
        switch planting.status {
        case .planned:
            return .gray
        case .active:
            return .green
        case .harvested:
            return .orange
        case .failed:
            return .red
        case .removed:
            return .black
        }
    }
}

#Preview {
    PlantingRowView(planting: Planting(datePlanted: Date(), quantity: 10, status: .active, xPosition: 0.0, yPosition: 0.0))
}
