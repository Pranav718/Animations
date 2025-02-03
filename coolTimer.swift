//
//  ContentView.swift
//  someAnimations
//
//  Created by Pranav Ray on 22/01/25.
//

import SwiftUI
import Combine

struct AdvancedTimerView: View {
    @StateObject private var timerManager = TimerManager()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                TimeDisplayView(timeRemaining: timerManager.timeRemaining)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.1))
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                            .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                    )

                HStack(spacing: 15) {

                    ControlButton(
                        title: timerManager.isRunning ? "Pause" : "Start",
                        color: timerManager.isRunning ? .white : .white
                    ) {
                        timerManager.isRunning ? timerManager.pause() : timerManager.start()
                    }
                    
                    ControlButton(title: "Reset", color: .white) {
                        timerManager.reset()
                    }
                }
                
                TimerConfigView(timerManager: timerManager)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.1))
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                            .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                    )
            }
            .padding()
        }
    }
}

class TimerManager: ObservableObject {
    @Published var timeRemaining: TimeInterval = 300
    @Published var isRunning = false
    
    var timer: Timer?
    var startTime: Date?
    
    func start() {
        guard !isRunning else { return }
        
        startTime = Date()
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            
            let elapsed = Date().timeIntervalSince(start)
            if self.timeRemaining - elapsed <= 0 {
                self.reset()
                self.playCompletionSound()
            } else {
                self.timeRemaining -= 0.1
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func reset() {
        pause()
        timeRemaining = 300
    }
    
    func setCustomTime(hours: Int, minutes: Int) {
        pause()
        timeRemaining = TimeInterval(hours * 3600 + minutes * 60)
    }
    
    private func playCompletionSound() {
        // will add sound effect implementation later
    }
}

struct TimeDisplayView: View {
    let timeRemaining: TimeInterval
    
    var body: some View {
        Text(timeString(from: timeRemaining))
            .font(.system(size: 62, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .monospacedDigit()
            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
            .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 10)
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d.%01d", minutes, seconds, milliseconds)
        }
    }
}

struct ControlButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(10)
                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}

struct TimerConfigView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var hours: Int = 0
    @State private var minutes: Int = 5
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Set Timer Duration")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
            
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr")
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 100)
                .clipped()
                
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min")
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 100)
                .clipped()
            }
            
            Button(action: {
                timerManager.setCustomTime(hours: hours, minutes: minutes)
            }) {
                Text("Set Timer")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
        }
        .padding()
    }
}


#Preview {
    AdvancedTimerView()
}

