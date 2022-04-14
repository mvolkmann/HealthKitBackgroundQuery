import Foundation

extension Date {
    static func fromMs(_ ms: Int64) -> Date {
        Date(timeIntervalSince1970: TimeInterval(ms / 1000))
    }

    static func mondayAt12AM() -> Date {
        Calendar(identifier: .iso8601)
            .date(from: Calendar(identifier: .iso8601).dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: Date()
            ))!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    func daysAgo(_ days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(
            byAdding: .day,
            value: -days,
            to: self
        )!
    }

    func hoursAgo(_ hours: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(
            byAdding: .hour,
            value: -hours,
            to: self
        )!
    }

    var milliseconds: Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    func secondsAfter(_ endDate: Date) -> Int {
        Int(endDate.timeIntervalSince1970 - timeIntervalSince1970)
    }

    // A computed property.
    var removeTimestamp: Date {
        let from = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: self
        )
        return Calendar.current.date(from: from)!
    }

    // Returns a String representation of the Date in "hh:mm:ss" format.
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: self)
    }

    var tomorrow: Date {
        let begin = removeTimestamp
        return Calendar.current.date(byAdding: .day, value: 1, to: begin)!
    }

    var yesterday: Date {
        let begin = removeTimestamp
        return Calendar.current.date(byAdding: .day, value: -1, to: begin)!
    }

    // Returns a String representation of the Date in "yyyy-mm-dd" format.
    var yyyymmdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    // Returns a String representation of the Date in "yyyy-mm-dd" format.
    var yyyymmddTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
}
