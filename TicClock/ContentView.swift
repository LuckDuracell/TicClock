//
//  ContentView.swift
//  TicClock
//
//  Created by Luke Drushell on 2/21/23.
//

import SwiftUI

struct ContentView: View {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State private var timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    @State private var currentTime = Date()
    
    @State private var position = (x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.4)
    
    @State private var moveCount = 0
    
    @State private var brightnessIndex = 0
    
    func moveClock() {
        let xRange = (min: width / 3, max: width / 1.5)
        let yRange = (min: height / 6, max: height / 2)
        
        withAnimation(.linear(duration: 5), {
            position.x = CGFloat.random(in: xRange.min...xRange.max)
            position.y = CGFloat.random(in: yRange.min...yRange.max)
        })
    }
    
    func screenBrightness() -> CGFloat {
        switch brightnessIndex {
        case 0:
            return 0.3
        case 1:
            return 0.5
        case 2:
            return 0.7
        default:
            return 0.3
        }
    }

    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
                .persistentSystemOverlays(.hidden)
                .onAppear(perform: {
                    UIApplication.shared.isIdleTimerDisabled = true
                })
            Text(currentTime, style: .time)
                .foregroundColor(.green.opacity(screenBrightness()))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .position(x: position.x, y: position.y)
        } .onReceive(timer, perform: { _ in
            currentTime = Date()
            moveCount += 1
            if moveCount > 20 {
                moveClock()
                moveCount = 0
            }
        })
        .onTapGesture {
            if brightnessIndex == 2 {
                brightnessIndex = 0
            } else {
                brightnessIndex += 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
