//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.

import SwiftUI

struct RippleEffectView: View {
    @State private var ripples: [Ripple] = []
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(ripples) { ripple in
                ripple.shape
                    .fill(ripple.color)
                    .frame(width: ripple.size, height: ripple.size)
                    .scaleEffect(ripple.scale)
                    .opacity(ripple.opacity)
                    .position(ripple.position) 
                    .animation(.easeOut(duration: ripple.duration), value: ripple.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + ripple.duration) {
                            removeRipple(ripple)
                        }
                    }
            }
        }
        .contentShape(Rectangle()) 
        .gesture(
            DragGesture()
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
                .onChanged { value in
                    addRipple(at: value.location)
                }
        )
    }
    
    func addRipple(at location: CGPoint) {
        let randomSize = CGFloat.random(in: 50...200) 
        let randomColor = Color.random() 
        let randomShape = ShapeType.random() 
        
        let newRipple = Ripple(
            id: UUID(),
            color: randomColor,
            size: randomSize,
            scale: 1,
            opacity: 1,
            duration: 1.0,
            position: location,
            shape: randomShape 
        )
        
        ripples.append(newRipple)
        
        
        withAnimation(.easeOut(duration: newRipple.duration)) {
            ripples[ripples.count - 1].scale = 0
            ripples[ripples.count - 1].opacity = 0 
        }
    }
    
    func removeRipple(_ ripple: Ripple) {
        ripples.removeAll { $0.id == ripple.id }
    }
}

#Preview {
    ContentView()
}
