//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.

import SwiftUI

struct Snowflake: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
}

struct SnowfallView: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(snowflakes) { snowflake in
                Circle()
                    .fill(Color.white)
                    .frame(width: snowflake.size, height: snowflake.size)
                    .position(snowflake.position)
                    .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: snowflake.position)
                    .onAppear {
                        startFalling(snowflake: snowflake)
                    }
            }
        }
        .onAppear {
            startSnowfall()
        }
    }
    
    func startSnowfall() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let size = CGFloat.random(in: 5...15) 
            let xPosition = CGFloat.random(in: 0...UIScreen.main.bounds.width) 
            let snowflake = Snowflake(position: CGPoint(x: xPosition, y: -size), size: size)
            snowflakes.append(snowflake)
        }
    }
    
    func startFalling(snowflake: Snowflake) {
        withAnimation {
            if let index = snowflakes.firstIndex(where: { $0.id == snowflake.id }) {
                snowflakes[index].position.y = UIScreen.main.bounds.height + snowflake.size
            }
        }
    }
    
    func cleanup() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View {
    var body: some View {
        SnowfallView()
    }
}


#Preview {
    ContentView()
}
