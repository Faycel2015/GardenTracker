//
//  HarvestLogView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData

struct HarvestLogView: View {
//    @Query private var harvestLogs: [HarvestLog]
    @Query(sort: \HarvestLog.date, order: .reverse) private var harvestLogs: [HarvestLog]
    @State private var groupByMonth = true
    
    var groupedLogs: [String: [HarvestLog]] {
        let dateFormatter = DateFormatter()
        
        if groupByMonth {
            dateFormatter.dateFormat = "MMMM yyyy"
        } else {
            dateFormatter.dateFormat = "yyyy"
        }
        
        let grouped = Dictionary(grouping: harvestLogs) { log in
            dateFormatter.string(from: log.date)
        }
        
        return grouped
    }
    
    var sortedGroupKeys: [String] {
        let keys = Array(groupedLogs.keys)
        
        if groupByMonth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            
            return keys.sorted { key1, key2 in
                if let date1 = dateFormatter.date(from: key1),
                   let date2 = dateFormatter.date(from: key2) {
                    return date1 > date2
                }
                return key1 > key2
            }
        } else {
            return keys.sorted().reversed()
        }
    }
    
    var body: some View {
        List {
            if harvestLogs.isEmpty {
                ContentUnavailableView(
                    "No Harvest Logs",
                    systemImage: "carrot",
                    description: Text("Record your harvests to see them here")
                )
            } else {
                Picker("Group By", selection: $groupByMonth) {
                    Text("Month").tag(true)
                    Text("Year").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 8)
                
                ForEach(sortedGroupKeys, id: \.self) { key in
                    if let logs = groupedLogs[key] {
                        Section(key) {
                            ForEach(logs) { log in
                                NavigationLink(destination: HarvestLogDetailView(harvestLog: log)) {
                                    HarvestLogRowView(harvestLog: log)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Harvest Logs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HarvestLogView()
}
