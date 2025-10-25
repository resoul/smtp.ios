import UIKit

struct StackedBarCategory {
    let name: String
    let color: UIColor
}

struct StackedBarData {
    let label: String
    let values: [Double]
}

struct StackedBarChartConfiguration {
    let categories: [StackedBarCategory]
    let data: [StackedBarData]
    
    var maxTotal: Double {
        data.map { $0.values.reduce(0, +) }.max() ?? 0
    }
}
