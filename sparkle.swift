//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.



import SwiftUI

struct SparkleView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 20, height: 20)
                .scaleEffect(isAnimating ? 0.5 : 1.0)
                .opacity(isAnimating ? 0.0 : 1.0)

            ForEach(0..<8) { index in
                RayView(angle: .degrees(Double(index) * 45))
                    .offset(x: isAnimating ? 30 : 0)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .opacity(isAnimating ? 0.0 : 1.0)
            }
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

struct RayView: View {
    let angle: Angle
    
    var body: some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 10, height: 3)
    }
}

struct SparkleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            SparkleView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            SparkleView()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview{
    ContentView()
}


