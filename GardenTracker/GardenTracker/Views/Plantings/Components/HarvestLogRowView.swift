//
//  HarvestLogRowView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct HarvestLogRowView: View {
    let harvestLog: HarvestLog
    
    var body: some View {
        HStack {
            if let imageData = harvestLog.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "carrot")
                    .font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(harvestLog.planting?.plant?.name ?? "Unknown")
                    .font(.subheadline)
                
                Text("\(harvestLog.quantity.formatted()) \(harvestLog.unit.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(harvestLog.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HarvestLogRowView(harvestLog: HarvestLog(
        quantity: 2.5,
        unit: .pounds
    ))
}
