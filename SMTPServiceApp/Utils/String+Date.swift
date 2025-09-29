import Foundation
import UIKit

extension String {
    func formattedDateString(dateStyle: DateFormatter.Style = .medium,
                             timeStyle: DateFormatter.Style = .none) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoFormatter.date(from: self) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: date)
    }
}
