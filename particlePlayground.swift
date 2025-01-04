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
