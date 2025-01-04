//
//  ContentView.swift
//  SomeAnimations
//
//  Created by Pranav Ray on 01/01/25.


import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var scale: CGFloat
    var opacity: Double
    var color: Color
    
    mutating func update(in size: CGSize) {
        position.x += velocity.x
        position.y += velocity.y

        if position.x < 0 || position.x > size.width {
            velocity.x *= -0.8
        }
        if position.y < 0 || position.y > size.height {
            velocity.y *= -0.8
        }

        velocity.y += 0.15

        velocity.x += Double.random(in: -0.5...0.5)

        opacity *= 0.99
        scale *= 0.995
    }
}

struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    @State private var timer: Timer?
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.position.x - particle.scale/2,
                        y: particle.position.y - particle.scale/2,
                        width: particle.scale,
                        height: particle.scale
                    )
                    
                    context.opacity = particle.opacity
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(particle.color)
                    )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        addParticles(at: gesture.location)
                    }
            )
            .onChange(of: timeline.date) { oldValue, newValue in
                updateParticles()
            }
        }
        .onAppear {
            startSystem()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startSystem() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            particles = particles.filter { 
                 $0.opacity > 0.1
            }
        }
    }
    
    func addParticles(at position: CGPoint) {
        for _ in 0..<5 {
            let particle = Particle(
                position: position,
                velocity: CGPoint(
                    x: Double.random(in: -5...5),
                    y: Double.random(in: -5...5)
                ),
                scale: CGFloat.random(in: 10...30),
                opacity: 1.0,
                color: colors.randomElement() ?? .white
            )
            particles.append(particle)
        }
    }
    
    func updateParticles() {
        for i in particles.indices {
            particles[i].update(in: UIScreen.main.bounds.size)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ParticleSystem()
            .ignoreSafeArea()
            .background(RadialGradient(colors: [.black,.white], center: .center, startRadius: 0, endRadius: 1111))
    }
}

#Preview {
    ContentView()
}
