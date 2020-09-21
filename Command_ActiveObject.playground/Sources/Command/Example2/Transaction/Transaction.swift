import Foundation

protocol Transaction {
    func validate()
    func execute()
}
