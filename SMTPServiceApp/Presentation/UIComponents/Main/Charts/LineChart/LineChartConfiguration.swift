import UIKit

struct LineChartConfiguration {
    var series: [LineChartSeries] = []
    var title: String = "Line Chart"
    var maxValue: Double = 20.0
    var yAxisStride: Double = 5.0
    var showDataLabels: Bool = true
    var showLegend: Bool = true
    
    // Удобный способ добавления серий
    mutating func addSeries(
        id: String,
        name: String,
        color: UIColor,
        dataPoints: [(Date, Double)]
    ) {
        let points = dataPoints.map { LineChartSeries.DataPoint(date: $0.0, value: $0.1) }
        series.append(LineChartSeries(id: id, name: name, color: color, dataPoints: points))
    }
}

// MARK: - Sample Data Builder
extension LineChartConfiguration {
    static func createSampleChart() -> LineChartConfiguration {
        var config = LineChartConfiguration()
        config.title = "Monthly Analytics"
        config.maxValue = 25.0
        
        let baseDate = Date().startOfDay.adding(.month, value: -11) ?? Date()
        
        let dates = (0..<12).compactMap { baseDate.adding(.month, value: $0) }
        let optimalData = dates.enumerated().map { (index, date) in
            (date, Double.random(in: 12...18))
        }
        config.addSeries(id: "optimal", name: "Optimal", color: .systemGreen, dataPoints: optimalData)

        let warningData = dates.enumerated().map { (index, date) in
            let base = 10.0 + sin(Double(index) * 0.5) * 3.0
            return (date, base + Double.random(in: -1...1))
        }
        config.addSeries(id: "warning", name: "Warning", color: .systemOrange, dataPoints: warningData)
        
        let criticalData = dates.enumerated().map { (index, date) in
            (date, Double.random(in: 3...8))
        }
        config.addSeries(id: "critical", name: "Critical", color: .systemRed, dataPoints: criticalData)
        
        let outsideData = dates.enumerated().map { (index, date) in
            (date, Double.random(in: 18...24))
        }
        config.addSeries(id: "outside", name: "Outside Range", color: .systemBlue, dataPoints: outsideData)
        
        let normalData = dates.enumerated().map { (index, date) in
            (date, Double.random(in: 10...15))
        }
        config.addSeries(id: "normal", name: "Normal", color: .systemPurple, dataPoints: normalData)
        
        let experimentalData = dates.enumerated().map { (index, date) in
            (date, Double.random(in: 5...22))
        }
        config.addSeries(id: "experimental", name: "Experimental", color: .systemTeal, dataPoints: experimentalData)
        
        return config
    }
}
