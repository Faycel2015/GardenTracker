//
//  FlowLayout.swift
//  GardenTracker
//
//  Created by FayTek on 3/10/25.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            
            if x + viewSize.width > width {
                // Move to next row
                y += maxHeight + spacing
                x = 0
                maxHeight = 0
            }
            
            x += viewSize.width + spacing
            maxHeight = max(maxHeight, viewSize.height)
        }
        
        height = y + maxHeight
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = bounds.width
        
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var maxHeight: CGFloat = 0
        
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            
            if x + viewSize.width > width + bounds.minX {
                // Move to next row
                y += maxHeight + spacing
                x = bounds.minX
                maxHeight = 0
            }
            
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(viewSize))
            
            x += viewSize.width + spacing
            maxHeight = max(maxHeight, viewSize.height)
        }
    }
}

// Sample view that uses FlowLayout
struct FlowLayoutDemoView: View {
    var body: some View {
        FlowLayout(spacing: 10) {
            // Sample tags/pills for preview
            ForEach(1...15, id: \.self) { index in
                Text("Tag \(index)")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}

#Preview {
    FlowLayoutDemoView()
}
