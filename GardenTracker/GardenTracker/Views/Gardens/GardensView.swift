//
//  GardensView.swift
//  GardenTracker
//
//  Created by FayTek on 3/9/25.
//

import SwiftUI
import SwiftData

struct GardensView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Garden.dateCreated) private var gardens: [Garden]
    @State private var showingCreateGarden = false
    
    var body: some View {
        NavigationStack {
            List {
                if gardens.isEmpty {
                    ContentUnavailableView(
                        "No Gardens Yet",
                        systemImage: "leaf.fill",
                        description: Text("Tap the + button to create your first garden")
                    )
                } else {
                    ForEach(gardens) { garden in
                        NavigationLink(destination: GardenDetailView(garden: garden)) {
                            GardenRowView(garden: garden)
                        }
                    }
                    .onDelete(perform: deleteGardens)
                }
            }
            .navigationTitle("My Gardens")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreateGarden = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateGarden) {
                NavigationStack {
                    CreateGardenView()
                }
            }
        }
    }
    
    private func deleteGardens(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(gardens[index])
        }
    }
}

// MARK: - Gardens Row View

struct GardenRowView: View {
    let garden: Garden
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(garden.name)
                    .font(.headline)
                
                Text("\(garden.width.formatted())' × \(garden.length.formatted())'")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let hardinessZone = garden.hardinessZone {
                    Text("Zone: \(hardinessZone)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(garden.beds?.count ?? 0) beds")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(garden.plantings?.count ?? 0) plants")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    GardensView()
}
