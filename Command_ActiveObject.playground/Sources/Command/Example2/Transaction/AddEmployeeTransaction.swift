import Foundation

class AddEmployeeTransaction: Transaction {
    var name: String, address: String
    var pay: PayClassification!
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
    func validate() {
        // check the validity of data
        // ...
        
        pay = SalariedClassification(pay: 1000)
    }
    func execute() {
        _ = Employee(name: name, address: address, pay: pay!)
        // Add to some database
        // ...
    }
    
}
