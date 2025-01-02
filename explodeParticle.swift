//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.

import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var velocity: CGVector
    var lifetime: Double
}

struct ParticleView: View {
    let particle: Particle
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .position(x: particle.position.x, y: particle.position.y)
    }
}

struct ContentView: View {
    @State private var particles: [Particle] = []
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                ForEach(particles) { particle in
                    ParticleView(particle: particle)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        createParticles(at: value.location, in: geometry.size)
                    }
            )
        }
        .onAppear {
            startParticleUpdater()
        }
        .onDisappear {
            stopParticleUpdater()
        }
    }
    
    func createParticles(at location: CGPoint, in size: CGSize) {
        for _ in 0..<10 {
            let randomVelocity = CGVector(
                dx: Double.random(in: -50...500),
                dy: Double.random(in: -50...500)
            )
            let randomSize = CGFloat.random(in: 4...80)
            let randomColor = Color(
                red: Double.random(in: 0.5...1.0),
                green: Double.random(in: 0.5...1.0),
                blue: Double.random(in: 0.5...1.0)
            )
            let particle = Particle(
                position: location,
                size: randomSize,
                color: randomColor,
                velocity: randomVelocity,
                lifetime: 5.0
            )
            particles.append(particle)
        }
    }
    
    func startParticleUpdater() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { _ in
            updateParticles()
        }
    }
    
    func stopParticleUpdater() {
        timer?.invalidate()
    }
    
    func updateParticles() {
        particles = particles.compactMap { particle in
            var updatedParticle = particle
            updatedParticle.position.x += CGFloat(updatedParticle.velocity.dx) * 0.016
            updatedParticle.position.y += CGFloat(updatedParticle.velocity.dy) * 0.016
            updatedParticle.lifetime -= 0.016
            return updatedParticle.lifetime > 0 ? updatedParticle : nil
        }
    }
}

#Preview {
    ContentView()
}
