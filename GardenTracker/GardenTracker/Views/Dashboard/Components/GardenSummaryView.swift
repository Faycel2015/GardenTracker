//
//  GardenSummaryView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct GardenSummaryView: View {
    let gardens: [Garden]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Gardens")
                    .headlineStyle()
                
                Spacer()
                
                NavigationLink(destination: GardensView()) {
                    Text("See All")
                        .captionStyle()
                }
            }
            
            if gardens.isEmpty {
                Text("No gardens yet")
                    .bodyStyle()
                    .padding(.vertical)
                
                NavigationLink(destination: CreateGardenView()) {
                    Label("Create a Garden", systemImage: "plus")
                        .modifier(ThemeManager.shared.primaryButtonStyle)
                        .frame(maxWidth: .infinity)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(gardens) { garden in
                            NavigationLink(destination: GardenDetailView(garden: garden)) {
                                GardenCardView(garden: garden)
                                    .frame(width: 160, height: 160)
                            }
                        }
                    }
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - Garden Card View

struct GardenCardView: View {
    let garden: Garden
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.foliage.opacity(0.3))
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.foliage)
                )
                .frame(height: 80)
            
            Text(garden.name)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
            
            Text("\(garden.width.formatted())' × \(garden.length.formatted())'")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(1)
            
            Text("\(garden.plantings?.count ?? 0) plants")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// Sample garden data for preview
extension Garden {
    static var sampleGardens: [Garden] {
        [
            Garden(name: "Vegetable Patch", width: 10, length: 20),
            Garden(name: "Herb Garden", width: 5, length: 8)
        ]
    }
}

#Preview {
    GardenSummaryView(gardens: Garden.sampleGardens)
}
