import Foundation

public class Engine {
    var itsCommand: LinkedList<Command> = LinkedList<Command>()
    
    public init() {}
    
    public func addCommand(command: Command) {
        itsCommand.append(value: command)
    }
    public func run() {
        while (!itsCommand.isEmpty) {
            let command = itsCommand.first!
            itsCommand.pop()
            try? command.execute()
        }
    }
}
