import Foundation

public protocol Command {
    func execute() throws
}
// MARK: - Wakeup Command
public class WakeupCommand: Command {
    private var _execute: () -> Void
    
    public init(execute: @escaping () -> Void) {
        self._execute = execute
    }
    public func execute() throws {
        self._execute()
    }
}
// MARK: - Sleep Command
public class SleepCommand: Command {
    private var engine: Engine
    private var wakeup: Command
    private var started = false
    private var sleepTime: Int64 = 0
    private var startTime: Int64 = 0
    
    public init(delay: Int64, engine: Engine, wakeup: Command) {
        self.engine = engine
        self.sleepTime = delay
        self.wakeup = wakeup
    }
    public func execute() throws {
        let currentTime = Date().current()
        if !started {
            started = true
            startTime = currentTime!
            self.engine.addCommand(command: self)
        } else if currentTime! - startTime < sleepTime {
            engine.addCommand(command: self)
        } else {
            engine.addCommand(command: wakeup)
        }
    }
}
