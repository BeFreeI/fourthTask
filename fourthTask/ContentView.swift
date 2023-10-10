//
//  ContentView.swift
//  fourthTask
//
//  Created by  Pavel Nepogodin on 10.10.23.
//

import SwiftUI

private enum Constants {
    static let iconHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 150
    static let minCircleScale: CGFloat = 0.88
    static let animationDuration: CGFloat = 0.22
    enum circleTransprency: Double {
        case start = 0
        case finish = 1
    }
}

struct ContentView: View {
    @State private var animationTriggered = false
    @State private var scale = 1.0
    
    var body: some View {
        Button(action: {animationTriggered.toggle()}) {
            NextLabelView(animationTriggered: $animationTriggered)
        }.buttonStyle(NextButtonStyle())
    }
}

struct NextButtonStyle: ButtonStyle {
    @State private var pressAnimationTriggered = false
    @State private var scale: CGFloat = 1
    @State private var transparency = Constants.circleTransprency.start
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .frame(height: Constants.buttonHeight)
                .foregroundColor(.gray.opacity(0.3))
                .opacity(transparency.rawValue)
                .scaleEffect(scale)
                .onChange(of: configuration.isPressed) { newValue in
                    if newValue {
                        pressAnimationTriggered = true
                        transparency = Constants.circleTransprency.finish
                        scale = Constants.minCircleScale
                    } else if !pressAnimationTriggered {
                        transparency = Constants.circleTransprency.start
                        scale = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + Constants.animationDuration
                    ) {
                        pressAnimationTriggered = false
                    }
                }
                .onChange(of: pressAnimationTriggered) { newValue in
                    if !newValue && !configuration.isPressed {
                        transparency = Constants.circleTransprency.start
                        scale = 1
                    }
                }
                .animation(
                    .linear(duration: Constants.animationDuration),
                    value: scale
                )
            
            configuration.label
                .foregroundColor(.blue)
                .scaleEffect(scale)
                .animation(
                    .easeInOut(duration: Constants.animationDuration),
                    value: scale
                )
        }
    }
}

struct NextLabelView: View {
    @Binding var animationTriggered: Bool
    
    private var nextImage: some View {
        Image(systemName: "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            nextImage
                .opacity(animationTriggered ? 1 : 0)
                .scaleEffect(animationTriggered ? 1 : 0, anchor: .trailing)
                .frame(
                    height: animationTriggered ? Constants.iconHeight : .zero
                )
            
            nextImage
                .frame(height: Constants.iconHeight)
            
            nextImage
                .opacity(animationTriggered ? 0 : 1)
                .scaleEffect(
                    animationTriggered ? 0 : 1,
                    anchor: .trailing
                )
                .frame(
                    height: animationTriggered ? .zero : Constants.iconHeight
                )
            
        }.animation(!animationTriggered ?
            .none : .interpolatingSpring(
                stiffness: 150,
                damping: 15
            ), value: animationTriggered)
        .onChange(of: animationTriggered) { newValue in
            if !newValue {
                animationTriggered = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
