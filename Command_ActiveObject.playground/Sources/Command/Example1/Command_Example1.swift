import Foundation

protocol HumanCommand {
    func execute()
}
class BabyHoodBehavior: HumanCommand {
    func execute() { print("Do sleep") }
}
class ChildHoodBehavior: HumanCommand {
    func execute() { print("Do play with some toy") }
}
class AdolescenceBehavior: HumanCommand {
    func execute() { print("Do study for future") }
}
class AdultHoodBehavior: HumanCommand {
    func execute() { print("Do earn money") }
}

enum Growth {
    case Babyhood, Childhood, Adolescence, Adulthood
}
extension Growth {
    var behavior: HumanCommand {
        switch self {
        case .Babyhood: return BabyHoodBehavior()
        case .Childhood: return ChildHoodBehavior()
        case .Adolescence: return AdolescenceBehavior()
        case .Adulthood: return AdultHoodBehavior()
        }
    }
}

class Human {
    private var age = 0 { didSet { self.setGrowth(age) } }
    private var growth: Growth = .Babyhood
    
    func grow() {
        for age in 1...27 {
            self.setAge(age)
            self.doTheirRole()
            Thread.sleep(forTimeInterval: 1)
        }
    }
    
    private func doTheirRole() { self.growth.behavior.execute() }
    private func setAge(_ age: Int) { self.age = age }
    private func setGrowth(_ age: Int) {
        switch age {
        case (0...7): growth = .Babyhood
        case (8...13): growth = .Childhood
        case (14...19): growth = .Adolescence
        default: growth = .Adulthood
        }
    }
}
