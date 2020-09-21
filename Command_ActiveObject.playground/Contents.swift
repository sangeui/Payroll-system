import Foundation
import XCTest

// MARK: - Active Object `TestSleepCommand`
// 어떤 이벤트를 기다리는 멀티스레드 프로그램 사이의 유사성을 비교할 수 있음.
/*
 멀티스레드 프로그램의 한 스레드가 어떤 이벤트를 기다리고 있을 때, 보통 이 스레드는 그 이벤트가 일어날 때까지
 그 스레드를 블록하는 운영체제 시스템 콜을 호출한다.
 아래 예시의 프로그램은 블록되지 않지만 기다리는 이벤트인 `(currentTime - startTime) < sleepTime` 이 아직 일어나지 않았다면
 다시 `SleepCommand` 자신을 다시 `Engine` 에 집어넣는다.
 */
class TestSleepCommand: XCTestCase {
    private var commandExecuted = false
    
    func testSleepCommand() {
        let wakeup = WakeupCommand { [weak self] in
            guard let self = self else { return }
            self.commandExecuted = true
        }
        let engine = Engine()
        let sleep = SleepCommand(delay: 1000, engine: engine, wakeup: wakeup)
        engine.addCommand(command: sleep)
        
        let start = Date().current()!
        engine.run()
        let stop = Date().current()!
        
        let sleepTime = stop - start
        
        XCTAssertTrue(sleepTime >= 1000, "SleepTime \(sleepTime) expected > 1000")
        XCTAssertTrue(sleepTime < 1100, "SleepTime \(sleepTime) expected < 1100")
        XCTAssertTrue(commandExecuted)
    }
}

//TestSleepCommand.defaultTestSuite.run()

// MARK: - The `Delayed Typer` Active Object Example
class DelayedTyper: Command {
    private var itsDelay: Int64!
    private var itsCharacter: Character!
    private static let engine: Engine = Engine()
    private static var stop = false
    
    public init() {}
    public init(delay: Int64, character: Character) {
        self.itsDelay = delay
        self.itsCharacter = character
    }
    func start() {
        DelayedTyper.engine.addCommand(command: DelayedTyper(delay: 100, character: "1"))
        DelayedTyper.engine.addCommand(command: DelayedTyper(delay: 300, character: "3"))
        DelayedTyper.engine.addCommand(command: DelayedTyper(delay: 500, character: "5"))
        DelayedTyper.engine.addCommand(command: DelayedTyper(delay: 700, character: "7"))
        
        let wakeupCommand = WakeupCommand {
            DelayedTyper.stop = true
        }
        
        DelayedTyper.engine.addCommand(command: SleepCommand(delay: 20000, engine: DelayedTyper.engine, wakeup: wakeupCommand))
        DelayedTyper.engine.run()
    }
    func execute() throws {
        print(itsCharacter!, terminator: "")
        if DelayedTyper.stop == false {
            delayAndRepeat()
        }
    }
    private func delayAndRepeat() {
        DelayedTyper.engine.addCommand(command: SleepCommand(delay: itsDelay, engine: DelayedTyper.engine, wakeup: self))
    }
}

//DelayedTyper().start()
