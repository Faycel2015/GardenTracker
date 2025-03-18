//
//  HarvestSummaryView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct HarvestSummaryView: View {
    @Query private var harvestLogs: [HarvestLog]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent Harvests")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: HarvestLogView()) {
                    Text("See All")
                        .font(.caption)
                }
            }
            
            if harvestLogs.isEmpty {
                Text("No harvest logs yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(harvestLogs.prefix(3)) { log in
                    HarvestLogRowView(harvestLog: log)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    HarvestSummaryView()
}
