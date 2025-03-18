//
//  SeasonTimelineView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct SeasonTimelineView: View {
    let suitableSeasons: [GrowingSeason]
    let currentSeason: GrowingSeason
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach([GrowingSeason.spring, .summer, .fall, .winter], id: \.self) { season in
                SeasonMarker(
                    season: season,
                    isCurrentSeason: season == currentSeason,
                    isSuitable: suitableSeasons.contains(season)
                )
            }
        }
        .frame(height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SeasonTimelineView(suitableSeasons: [.spring, .summer], currentSeason: .spring)
}
