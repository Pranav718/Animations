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
        .onTapGesture { location in
            addRipple(at: location)
        }
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
    var position: CGPoint 
    var shape: ShapeType 
}

enum ShapeType: Shape {
    case circle
    case rectangle
    case triangle
    
    func path(in rect: CGRect) -> Path {
        switch self {
        case .circle:
            return Path { path in
                path.addEllipse(in: rect)
            }
        case .rectangle:
            return Path { path in
                path.addRect(rect)
            }
        case .triangle:
            return Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.closeSubpath()
            }
        }
    }
    
    static func random() -> ShapeType {
        let shapes: [ShapeType] = [.circle, .rectangle, .triangle]
        return shapes.randomElement() ?? .circle
    }
}

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

struct ContentView: View {
    var body: some View {
        RippleEffectView()
    }
}

#Preview {
    ContentView()
}
