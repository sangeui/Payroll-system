import Foundation

extension Date {
    public func current() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
