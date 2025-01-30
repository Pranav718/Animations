//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.

import SwiftUI

struct BubbleView: View {
    @State private var isAnimating = false
    let position: CGPoint
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(Color.blue.opacity(0.3))
            .frame(width: 10, height: 10)
            .position(position)
            .scaleEffect(isAnimating ? 1.5 : 0.5)
            .opacity(isAnimating ? 0 : 0.7)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever()
                        .delay(delay)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ForEach(0..<12) { index in
            let angle = Double(index) * (360.0 / 12.0)
            let radius: CGFloat = 150
            let x = cos(angle * .pi / 180) * radius + 125
            let y = sin(angle * .pi / 180) * radius + 125
            
            BubbleView(
                position: CGPoint(x: x, y: y),
                delay: Double(index) * 0.2
            )
        }
    }
}
