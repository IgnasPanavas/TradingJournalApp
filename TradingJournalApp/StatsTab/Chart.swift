//
//  Chart.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/19/24.
//

import SwiftUI
import Charts

struct ChartOptions {
    private var xAxisLabelFont: Font
    private var xAxisLabelColor: Color
    private var yAxisLabelFont: Font
    private var yAxisLabelColor: Color
    private var gridLineColor: Color
    @Environment(\.theme) var theme
    
    // Add more options as needed
    init() {
        xAxisLabelFont = .caption
        xAxisLabelColor = .white
        yAxisLabelFont = .caption
        yAxisLabelColor = .white
        gridLineColor = .white
    }
    init(xAxisLabelFont: Font = .caption, xAxisLabelColor: Color = .white, yAxisLabelFont: Font = .caption, yAxisLabelColor: Color = .white, gridLineColor: Color = .white) {
        self.xAxisLabelFont = xAxisLabelFont
        self.xAxisLabelColor = xAxisLabelColor
        self.yAxisLabelFont = yAxisLabelFont
        self.yAxisLabelColor = yAxisLabelColor
        self.gridLineColor = gridLineColor
    }
    func getXAxisLabelFont() -> Font {
        return xAxisLabelFont
    }
    func getXAxisLabelColor() -> Color {
        return xAxisLabelColor
    }
    func getYAxisLabelColor() -> Font {
        return yAxisLabelFont
    }
    func getYAxisLabelColor() -> Color {
        return yAxisLabelColor
    }
    func getGridLineColor() -> Color {
        return gridLineColor
    }
    
}


struct ChartView: View {
    let chartData: [ChartData]
    let chartOptions: ChartOptions
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.7))
                .frame(width: 350, height: 260)
            VStack {
                Chart(chartData) {
                    LineMark(
                        x: .value("Date", DateFormatter.dayFormatter.string(from: $0.date)),
                        y: .value("Profit", $0.value)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(width: 300, height: 200)
                .background(Color.clear)
                .clipShape(Rectangle())
                .chartXAxis(.visible)
                .chartXAxis(){
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel().foregroundStyle(chartOptions.getXAxisLabelColor())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .stride(by: calculateStride(forNumLevels: 10))) { value in
                        AxisGridLine().foregroundStyle(chartOptions.getGridLineColor())
                        AxisValueLabel().foregroundStyle(chartOptions.getYAxisLabelColor())
                    }
                }
                .chartYScale(domain: calculateYAxisDomain())
            }
            .padding()
        }
    }
    func calculateYAxisDomain() -> ClosedRange<Double> {
        let allYValues = chartData.map { $0.value }
        let minValue = allYValues.min() ?? 0
        let maxValue = allYValues.max() ?? 0
        let absoluteMax = max(abs(minValue), abs(maxValue))
        
        // Calculate padding as a percentage of the absolute max value
        let padding = absoluteMax * 0.1 // Adjust the padding percentage as needed
        
        return (minValue - padding)...(maxValue + padding)
    }
    
    func calculateStride(forNumLevels numLevels: Int) -> Double {
        let allYValues = chartData.map { $0.value }
        let minValue = allYValues.min() ?? 0
        let maxValue = allYValues.max() ?? 0
        let range = maxValue - minValue
        
        // Ensure at least 19 levels
        guard range > 0 else { return 0 }
        
        // Calculate the stride
        let stride = range / Double(numLevels - 1)
        
        return stride
    }
}




extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

struct GenericChartView: View {
    let chartData: [ChartData]
    let title: String
    let chartOptions: ChartOptions
    
    init(chartData: [ChartData], title: String, chartOptions: ChartOptions) {
        self.chartData = chartData
        self.title = title
        self.chartOptions = chartOptions
    }
    struct ChartBackground: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.7))
                .frame(width: 350, height: 260)
        }
    }
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 5)
            
            if chartData.isEmpty {
                ZStack { // Add a ZStack to layer the rectangle and text
                    ChartBackground()
                    Text("No Data")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            } else {
                ChartView(chartData: chartData, chartOptions: chartOptions)
            }
        }
        .padding() // Add padding around the chart or the "No Data" message
    }
}


struct StackedBarChartView: View {
    let chartData: TradeChartData
    let chartOptions: ChartOptions
    
    let visualizationThreshold = 2500.0
    
    // Define the trade types to include
    let tradeTypes: [TradeType] = [.optionTrade, .futureTrade, .stockTrade]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 350, height: 260)
            VStack {
                Chart {
                    let chartDataByType = chartData.tradeChartDataGroupedByType()
                    
                    ForEach(chartDataByType.keys.sorted(), id: \.self) { tradeType in
                        if let chartData = chartDataByType[tradeType] {
                            ForEach(chartData) { data in
                                BarMark(
                                    x: .value("Date", DateFormatter.dayFormatter.string(from: data.date)),
                                    y: .value("Profit", limitValue(data.value, threshold: visualizationThreshold))
                                )
                                .foregroundStyle(color(for: data.tradeType))
                                .opacity(1.0)
                                .annotation(position: .top) {
                                    if data.value > visualizationThreshold {
                                        Text(String(format: "%.0f", data.value)) // Format as needed
                                            .font(.caption)
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                .frame(width: 300, height: 200)
                .background(Color.clear)
                .clipShape(Rectangle())
                .chartXAxis(.visible)
                .chartXAxis(){
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel().foregroundStyle(chartOptions.getXAxisLabelColor())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .stride(by: calculateStride(forNumLevels: 10))) { value in
                        AxisGridLine().foregroundStyle(chartOptions.getGridLineColor())
                        AxisValueLabel().foregroundStyle(chartOptions.getYAxisLabelColor())
                    }
                }
                .chartYScale(domain: calculateYAxisDomain())
                
            }
            
            .padding()
            
        }
    }
    func limitValue(_ value: Double, threshold: Double) -> Double {
        return min(value, threshold)
    }
    func calculateYAxisDomain() -> ClosedRange<Double> {
        let allYValues = chartData.tradesChartData().map { $0.value }

        // Ensure all values are positive for log scale
        let minValue = allYValues.filter { $0 > 0 }.min() ?? 1  // Use 1 if no positive values
        let maxValue = allYValues.max() ?? 100 // Use a reasonable default if no max

        // Calculate padding as a percentage of the absolute max value
        let padding = 0.1 * maxValue // Adjust the padding percentage as needed

        return log10(minValue - padding)...log10(maxValue + padding) // Logarithmic domain
    }
    
    func calculateStride(forNumLevels numLevels: Int) -> Double {
        let allYValues = chartData.tradesChartData().map { $0.value }
        let minValue = allYValues.min() ?? 0
        let maxValue = allYValues.max() ?? 0
        let range = maxValue - minValue
        
        // Ensure at least 19 levels
        guard range > 0 else { return 0 }
        
        // Calculate the stride
        let stride = range / Double(numLevels - 1)
        
        return stride
    }
    func color(for tradeType: TradeType) -> Color {
        switch tradeType {
        case .optionTrade: return .blue
        case .futureTrade: return .green
        case .stockTrade:  return .orange
        default:           return .gray // In case more cases are added in the future
        }
    }
}


