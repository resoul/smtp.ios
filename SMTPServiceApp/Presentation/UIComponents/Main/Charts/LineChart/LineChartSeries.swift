import UIKit

struct LineChartSeries {
    let id: String
    let name: String
    let color: UIColor
    let dataPoints: [DataPoint]
    
    struct DataPoint {
        let date: Date
        let value: Double
    }
}
