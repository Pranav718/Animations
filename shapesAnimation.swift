//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.

import SwiftUI

struct RippleEffectView: View {
    @State private var ripples: [Ripple] = []
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(ripples) { ripple in
                Circle()
                    .fill(ripple.color)
                    .frame(width: ripple.size, height: ripple.size)
                    .scaleEffect(ripple.scale)
                    .opacity(ripple.opacity)
                    .position(ripple.position) // Set the position of the ripple
                    .animation(.easeOut(duration: ripple.duration), value: ripple.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + ripple.duration) {
                            removeRipple(ripple)
                        }
                    }
            }
        }
        .contentShape(Rectangle()) // Make the entire area tappable
        .onTapGesture { location in
            addRipple(at: location)
        }
    }
    
    private func addRipple(at location: CGPoint) {
        let newRipple = Ripple(
            id: UUID(),
            color: Color.blue,
            size: 0,
            scale: 1,
            opacity: 1,
            duration: 1.0,
            position: location // Set the position to the touch location
        )
        
        ripples.append(newRipple)
        
        // Animate the ripple
        withAnimation(.easeOut(duration: newRipple.duration)) {
            ripples[ripples.count - 1].size = 200 // Final size of the ripple
            ripples[ripples.count - 1].scale = 0 // Scale to 0 for the animation
            ripples[ripples.count - 1].opacity = 0 // Fade out
        }
    }
    
    private func removeRipple(_ ripple: Ripple) {
        ripples.removeAll { $0.id == ripple.id }
    }
}

struct Ripple: Identifiable {
    let id: UUID
    var color: Color
    var size: CGFloat
    var scale: CGFloat
    var opacity: Double
    var duration: Double
    var position: CGPoint // Add position property
}

struct ContentView: View {
    var body: some View {
        RippleEffectView()
    }
}

#Preview {
    ContentView()
}
