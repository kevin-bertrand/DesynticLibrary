//
//  PieChartView.swift
//  
//
//  Created by Kevin Bertrand on 12/01/2023.
//

import SwiftUI

public struct PieChartView: View {
    // MARK: Constants
    static private var ANIMATION_DURATION: Double = 2
    
    // MARK: State properties
    @State private var drawingStroke = true
    @State private var showDetail = false
    @State private var details = ""
    @State private var animationStroke: [Bool] = []
    
    // MARK: Environment properties
    @Environment(\.showLegend) var showLegend
    @Environment(\.showTotal) var showTotal
    @Environment(\.chartSymbol) var symbol
    @Environment(\.chartScale) var chartScale
    @Environment(\.legendType) var legendType
    
    // MARK: Properties
    private let values: [Values]
    private let animation = Animation
        .linear(duration: PieChartView.ANIMATION_DURATION)
    private let total: String
    
    // MARK: Initializer
    public init(values: [Double],
                names: [String],
                colors: [Color]) {
        var encodedValues: [Values] = []
        let sum = values.reduce(0.00, +)
        var endAngle: CGFloat = .zero
        
        for (index, value) in values.enumerated() {
            var name = ""
            
            if index < names.count {
                name = names[index]
            }
            
            var color = Color.accentColor
            
            if index < colors.count {
                color = colors[index]
            }
            
            let percent = value / sum
            let angle = 1 * percent
            
            let currentEndAngle: CGFloat = endAngle + angle
            encodedValues.append(.init(id: index,
                                       value: value,
                                       percent: percent * 100,
                                       name: name,
                                       startAngle: endAngle,
                                       endAngle: currentEndAngle,
                                       color: color,
                                       duration: (PieChartView.ANIMATION_DURATION * percent)))
            endAngle = currentEndAngle
        }
        
        self.values = encodedValues
        self.animationStroke = Array(repeating: false, count: self.values.count)
        self.total = sum.twoDigitPrecision
    }
    
    // MARK: Body
    public var body: some View {
        VStack {
            Group {
                if values.allSatisfy({$0.value == 0}) {
                    Text(NSLocalizedString("no_data", comment: ""))
                } else {
                    ZStack {
                        Group {
                            if showDetail {
                                Text(details)
                            } else if showTotal {
                                Text("\(total)\(symbol != "" ? " \(symbol)" : "")")
                            }
                        }
                        .multilineTextAlignment(.center)
                        .font(chartScale >= 1 ? .largeTitle.bold() : .title3.bold())
                        .padding(60)
                        
                        ForEach(values) { value in
                            getArcCircle(value: value)
                                .animation(Animation.linear(duration: value.duration), value: animationStroke)
                        }
                        .rotationEffect(.degrees(-90))
                    }
                }
            }
            .padding(30)
        
            if showLegend {
                switch legendType {
                case .oneColumn:
                    getColumnLegend(values)
                case .horizontalScroll:
                    getScrollViewLegent(values)
                }
            }
        }
        .onAppear {
            startAnimation()
            drawingStroke.toggle()
        }
        
    }
    
    private func startAnimation() {
        var totalDuration = 0.0
        for value in values {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: TimeInterval(totalDuration), repeats: false) { _ in
                    self.animationStroke[value.id] = true
                }
                totalDuration += value.duration
            }
        }
    }
    
    // MARK: Methods
    /// Getting arc circle
    private func getArcCircle(value: Values) -> AnyView {
        @State var endAngle: CGFloat = 0
        @State var isSelected: Bool = false
        @State var scale: CGFloat = 1
        
        return .init(
            Circle()
                .trim(from: value.startAngle, to: animationStroke[value.id] ? value.endAngle : value.startAngle)
                .stroke(value.color, lineWidth: 50 * chartScale)
                .scaleEffect(scale)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            withAnimation {
                                if !isSelected {
                                    self.details = """
                                        \(value.name)\n\(value.value.twoDigitPrecision)\(symbol != "" ? " \(symbol)" : "")
                                        """
                                    isSelected = true
                                    self.showDetail = true
                                    scale = 2
                                }
                            }
                        })
                        .onEnded({ _ in
                            withAnimation {
                                isSelected = false
                                self.showDetail = false
                                self.details = ""
                                scale = 1
                            }
                        })
                )
                .animation(.linear(duration: 1), value: scale)
        )
    }
    
    /// Getting column legend
    private func getColumnLegend(_ values: [Values]) -> AnyView {
        return .init(
            VStack {
                Divider()
                ForEach(values) { value in
                    HStack {
                        Rectangle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(value.color)
                        Text(value.name)
                            .font(.title3.bold())
                        
                        Spacer()
                        
                        VStack {
                            Text("\(value.value.twoDigitPrecision)\(symbol != "" ? " " + symbol : "")")
                                .font(.title3.bold())
                            Text("\((value.percent * 100).twoDigitPrecision) %")
                                .font(.callout)
                        }
                    }
                    .padding(10)
                    Divider()
                }
            }
            .padding()
        )
    }
    
    /// Getting horizontal scroll view legent
    private func getScrollViewLegent(_ values: [Values]) -> AnyView {
        return .init(
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(values) { value in
                        HStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(value.color)
                            
                            VStack(alignment: .leading) {
                                Text(value.name)
                                    .font(.title3.bold())
                                
                                Group {
                                    Text("\(value.value.twoDigitPrecision)\(symbol != "" ? " \(symbol)" : "")")
                                    Text("\(value.percent.twoDigitPrecision) %")
                                }
                                .font(.caption)
                            }
                            
                            if value.id != (values.count-1) {
                                Divider()
                                    .frame(height: 60)
                            }
                        }
                    }
                }
                .padding()
            }
        )
    }
    
    // MARK: Structures
    struct Values: Identifiable {
        let id: Int
        let value: Double
        let percent: Double
        let name: String
        let startAngle: CGFloat
        let endAngle: CGFloat
        let color: Color
        let duration: Double
    }
    
    // MARK: Enumeration
    public enum LegendType {
        case oneColumn, horizontalScroll
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [10, 15, 25, 35],
                     names: ["One", "Two"],
                     colors: [.red, .green, .yellow, .blue])
    }
}

extension PieChartView {
    func environments() -> some View {
        self.environment(\.showLegend, self.showLegend)
    }
}

// MARK: Show legend
private struct ShowLegendKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

// MARK: Show total
private struct ShowTotalKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

// MARK: Symbol
private struct ChartSymbolKey: EnvironmentKey {
    static let defaultValue: String = ""
}

// MARK: Line width
private struct ScaleEffectKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

// MARK: Legend type
private struct LegendTypeKey: EnvironmentKey {
    static let defaultValue: PieChartView.LegendType = .oneColumn
}

// MARK: Environment Values extension
private extension EnvironmentValues {
    var showLegend: Bool {
        get { self[ShowLegendKey.self] }
        set { self[ShowLegendKey.self] = newValue }
    }
    
    var showTotal: Bool {
        get { self[ShowTotalKey.self] }
        set { self[ShowTotalKey.self] = newValue }
    }
    
    var chartSymbol: String {
        get { self[ChartSymbolKey.self] }
        set { self[ChartSymbolKey.self] = newValue }
    }
    
    var chartScale: CGFloat {
        get { self[ScaleEffectKey.self] }
        set { self[ScaleEffectKey.self] = newValue }
    }
    
    var legendType: PieChartView.LegendType {
        get { self[LegendTypeKey.self] }
        set { self[LegendTypeKey.self] = newValue }
    }
}

// MARK: Extension modifier
public extension View {
    func showLegend(_ value: Bool = true) -> some View {
        environment(\.showLegend, value)
    }
    
    func showTotal(_ value: Bool = true) -> some View {
        environment(\.showTotal, value)
    }
    
    func setSymbol(_ value: String) -> some View {
        environment(\.chartSymbol, value)
    }
    
    func chartScale(_ value: CGFloat) -> some View {
        environment(\.chartScale, value)
    }
    
    func legendType(_ value: PieChartView.LegendType) -> some View {
        environment(\.legendType, value)
    }
}
