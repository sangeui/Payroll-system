import Foundation

protocol PayClassification {
    func calculatePay()
}

// MARK: - Commissioned Classification
class CommissionedClassification: PayClassification {
    var basePay: Int
    var commissionRate: Double
    var receiptList: [SalesReceipt] = []
    
    init(pay: Int, commissionRate: Double) {
        self.basePay = pay
        self.commissionRate = commissionRate
    }
    
    func calculatePay() {}
}
struct SalesReceipt {
    var date: String, amount: Int
}
// MARK: - Salaried Classification
class SalariedClassification: PayClassification {
    var monthlyPay: Int
    
    init(pay: Int) {
        self.monthlyPay = pay
    }
    
    func calculatePay() {}
}
// MARK: - Hourly Classification
class HourlyClassification: PayClassification {
    var hourlyRate: Int
    var timecardList: [TimeCard] = []
    
    init(pay: Int) {
        self.hourlyRate = pay
    }
    
    func calculatePay() {}
}
struct TimeCard {
    var date: String, hours: Int
}
