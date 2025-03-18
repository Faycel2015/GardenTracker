//
//  TagsView.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct TagsView: View {
    let tags: [String]
    var tagColor: Color = .blue
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(tagColor.opacity(0.2))
                    .foregroundColor(tagColor)
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    TagsView(tags: ["Spring", "Summer", "Fall"])
}
