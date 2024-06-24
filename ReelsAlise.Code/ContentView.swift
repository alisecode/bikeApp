//
//  ContentView.swift
//  ReelsAlise.Code
//
//  Created by Alisa Serhiienko on 23.06.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var isRunning = false
    @State private var distance: Float = 0.00
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        
        VStack(alignment: .trailing, spacing: 0) {
            Spacer()
            BikerView(isRunning: $isRunning)
                .frame(width: 240, height: 225)
                .padding(.horizontal)
            
            ZStack {
                Rectangle()
                    .fill(Color(red: 20/255, green: 10/255, blue: 18/255))
                    .frame(height: 160)
                
                Button(action: {
                    !isRunning ? run() : stop()
                }, label: {
                    Text(!isRunning ? "Let's go!" : "Stop")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.clear)
                                .stroke(.orange, style: .init(lineWidth: 1))
                        }
                })
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(alignment: .bottom) {
            Image(.mountain3)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 429)
                .offset(y: 30)
        }
        .background {
            ZStack {
                 EndlessScrollingImageView(image: .topMountain)
                    .offset(y: -200)
                     
                Image(.mountain1)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 252)
                    .clipped()
                    //.background(.red)
                    .offset(y: -140)
                
                Image(.mountain2)
                    .frame(height: 282)
                 
    
                EndlessScrollingImageView(image: .bottomMountain, axis: .trailing, speed: 30)
                    .offset(y: 10)
                
                EndlessScrollingImageView(image: .middleMountain, axis: .leading, speed: 15)
                    .offset(y: 75)
            }
            
        }
        .background(Color(red: 243/255, green: 200/255, blue: 188/255))
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color(red: 249/255, green: 249/255, blue: 249/255))
                .frame(width: 76)
                .padding(.top, 98)
                .padding(.horizontal, 32)
        }
        .overlay(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Total Distance:")
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(alignment: .bottom) {
                    Text(String(format: "%0.1f", distance))
                        .multilineTextAlignment(.leading)
                        .contentTransition(.numericText())
                        .font(.system(size: 72, weight: .light))
                    
                    Text("km")
                        .font(.system(size: 56, weight: .light))
                }
                .padding(.top, 10)
               
            }
           .padding(.horizontal)
           .offset(y: -130)
            
            
        }
        .ignoresSafeArea()
    }
    
    private func run() {
        isRunning.toggle()
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { second in
                withAnimation {
                    distance += 0.1
                }
            }
    }
    
    private func stop() {
        isRunning.toggle()
        cancellable?.cancel()
    }
}


struct BikerView: View {
    
    @Binding var isRunning: Bool
    
    var body: some View {
        GeometryReader { proxy in
            Image("biker")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(alignment: .bottomLeading) {
                    makeWheelView(width: proxy.size.width * 0.4)
                }
                .overlay(alignment: .bottomTrailing) {
                    makeWheelView(width: proxy.size.width * 0.35)
                }
        }
        
    }
    
    private func makeWheelView(width: CGFloat) -> some View {
        Image("wheel1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
            .rotationEffect(isRunning ? .degrees(-360) : .degrees(0))
            .animation(isRunning ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: isRunning)
    }
}

@available(iOS 17, *)
#Preview {
    ContentView()
}

struct EndlessScrollingImageView: View {
    let image: UIImage
    var axis: Axis = .leading
    var speed: CGFloat = 100.0
    
    @State private var offset: CGFloat = 0
    
    enum Axis {
        case trailing, leading
    }

    var body: some View {
            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let distance = speed * now.truncatingRemainder(dividingBy: image.size.width / speed)
                
                ZStack {
                    ForEach(0..<2, id: \.self) { index in
                        
                        let xOffset = CGFloat(index) * image.size.width - distance
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: image.size.width)
                            .offset(x: axis == .leading ? xOffset : -(xOffset))
                    }
                }
            }
    }
}

