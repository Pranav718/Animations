//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.


import SwiftUI

struct PulsatingRingsView: View {
    @State private var isAnimating = false
    @State private var rotation = 0.0
    @State private var scale: CGFloat = 1.0
    
    let gradientColors = [
        Color(red: 0.4, green: 0.2, blue: 0.9),
        Color(red: 0.9, green: 0.3, blue: 0.5),
        Color(red: 0.2, green: 0.8, blue: 0.7)
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            RadialGradient(
                gradient: Gradient(colors: [.black.opacity(0.8), .black]),
                center: .center,
                startRadius: 2,
                endRadius: 650
            )
            .edgesIgnoringSafeArea(.all)
            
            
            ForEach(0..<5) { index in
                Circle()
                    .stroke(lineWidth: 2)
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: gradientColors),
                            center: .center,
                            startAngle: .degrees(isAnimating ? 360 : 0),
                            endAngle: .degrees(0)
                        )
                    )
                    .scaleEffect(isAnimating ? scale + CGFloat(index) * 0.2 : 0.2)
                    .rotationEffect(.degrees(rotation + Double(index) * 15))
                    .opacity(isAnimating ? 0.8 - Double(index) * 0.15 : 0)
                    .blur(radius: isAnimating ? 0 : 10)
            }
            
    
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .shadow(color: gradientColors[0], radius: 20, x: 0, y: 0)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .blur(radius: 4)
                )
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeInOut(duration: 3)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
                scale = 1.5
            }
            
            withAnimation(
                Animation
                    .linear(duration: 10)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        PulsatingRingsView()
    }
}

#Preview {
    ContentView()
}

