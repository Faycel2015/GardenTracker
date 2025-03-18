//
//  SeasonMarker.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI
import SwiftData
import WeatherKit

struct SeasonMarker: View {
    let season: GrowingSeason
    let isCurrentSeason: Bool
    let isSuitable: Bool
    
    var body: some View {
        VStack {
            Text(seasonAbbreviation)
                .font(.caption)
                .fontWeight(isCurrentSeason ? .bold : .regular)
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .overlay(
            isCurrentSeason ?
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary, lineWidth: 2)
            : nil
        )
    }
    
    private var seasonAbbreviation: String {
        switch season {
        case .spring: return "Spr"
        case .summer: return "Sum"
        case .fall: return "Fall"
        case .winter: return "Win"
        case .yearRound: return "Any"
        }
    }
    
    private var backgroundColor: Color {
        if !isSuitable {
            return Color.gray.opacity(0.2)
        }
        
        switch season {
        case .spring: return Color.green.lighter(by: 30)
        case .summer: return Color.yellow.lighter(by: 20)
        case .fall: return Color.orange.lighter(by: 20)
        case .winter: return Color.blue.lighter(by: 30)
        case .yearRound: return Color.purple.lighter(by: 30)
        }
    }
    
    private var textColor: Color {
        if !isSuitable {
            return Color.gray
        }
        return isCurrentSeason ? .primary : .primary.opacity(0.8)
    }
}

#Preview {
    SeasonMarker(season: .spring, isCurrentSeason: true, isSuitable: true)
}
