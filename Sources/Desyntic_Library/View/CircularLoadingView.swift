//
//  CircularLoadingView.swift
//  
//
//  Created by Kevin Bertrand on 06/01/2023.
//

import SwiftUI

public struct CircularLoadingView: View {
    @State private var isLoading = false
    let color: Color
    let animation: Bool = false
    let numberOfLines: Range<Int>
    let scale: Double
    let speed: Double
    let spacing: Double
    let lineWidth: Double
    
    public init(color: Color = .accentColor,
         numberOfLines: Int = 4,
         scale: Double = 1,
         speed: Double = 1,
         spacingFactor: Double = 1,
         lineWidthFactor: Double = 1) {
        self.color = color
        self.numberOfLines = 0..<numberOfLines
        self.scale = scale
        self.speed = speed
        self.spacing = 20 * spacingFactor
        self.lineWidth = 5 * lineWidthFactor * scale
    }
    
    public var body: some View {
        ZStack {
            ForEach(numberOfLines) { delta in
                getCircle(antiClockWise: delta % 2 == 0,
                          delta: delta,
                          scale: scale,
                          speed: speed,
                          spacing: spacing,
                          lineWidth: lineWidth)
            }
        }
        .onAppear() {
            self.isLoading = true
        }
    }
    
    private func getCircle(antiClockWise: Bool,
                           delta: Int,
                           scale: Double,
                           speed: Double,
                           spacing: Double,
                           lineWidth: Double) -> AnyView {
        let frame: CGFloat = (100 + CGFloat(delta) * spacing) * scale
        let trimStart: CGFloat = 0 + 0.25 * CGFloat(delta)
        let trimEnd: CGFloat = trimStart + 0.4
        let effect: Double = isLoading ? ( antiClockWise ? -360 : 360 ) : 0
        let duration: Double = 1.4 * 1/speed
        
        return .init(
            Circle()
                .trim(from: trimStart, to: trimEnd)
                .stroke(color, lineWidth: lineWidth)
                .frame(width: frame, height: frame)
                .rotationEffect(Angle(degrees: effect))
                .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: effect)
        )
    }
}

struct CircularLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CircularLoadingView()
    }
}
