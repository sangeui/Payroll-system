- [Introduction](#INTRODUCTION)  
- [Use cases](#USE-CASES)
	- [ ] 테스트 구현 해보기
	- [ ] UML 다이어그램 그려보기
- [Design Patterns](#DESIGN-PATTERNS)
	- Command & Active Object

#### INTRODUCTION

---

**급여 관리 시스템의 기본 명세**

이 시스템은 회사 직원 및 각자의 출퇴근 같은 데이터로 구성되어 있다. 

이 시스템은 각 직원에게 임금을 지급해야 하며, 정확한 시간에 임금에 해당하는 액수를 직원들이 지정한 방식으로 지급받아야 하다. 

임금에서 다양한 공제가 가능해야 한다. 

**시간제 직원의 관리**

어떤 직원은 `시간제` 로 일을 한다. 이러한 직원들의 레코드에는 `시급 필드` 가 포함되어, 해당 필드의 값에 따라 임금을 지급받는다. 

시급을 계산하기 위해 이 직원들에게서 매일 `날짜와 일한 시간` 을 기록한 출퇴근 카드를 제출 받는다. 

하루에 8시간 이상 일하게 되면, `초과된 시간에 대해서 1.5 배의 시급` 을 받는다.

이들은 매주 금요일마다 임금을 지급받는다.

**월급제 직원의 관리**

어떤 직원은 고정된 월급을 받으며 매달 마지막 평일에 임금을 지급받는다. 
이러한 직원들의 레코드에는 `월급 액수` 라는 필드가 더해진다. 

*수수료를 받는 월급제 직원*

월급을 받는 직원 중 일부는, 별도로 판매량에 기반을 둔 수수로를 지급받는다. 
그렇기 때문에 이들은 날짜와 판매량이 기록되어 있는 판매 영수증을 추가로 제출한다. 

판매량에 대한 수수료를 지급 받으므로 이들 레코드에는 `수수료율` 필드가 더해질 것이다. 

이들은 격주로 금요일마다 임금을 받는다.

**임금 지급 방법**

모든 직원은 임금을 지급받을 방법을 선택해야 한다. 
- 우편으로 급여 지급 수표 수령
- 급여 담당자에게 맡겨 두었다가 수령
- 은행 계좌로 입금

**조합에 속한 직원**

어떤 직원은 조합에 속하며 이러한 직원들의 레코드에는 `주당 조합비 비율` 필드를 포함한다. 이 조합비는 임금에서 공제된다. 

또한 조합은 조합원 개인에게 공제액을 부과할 수도 있다. 

이 공제액은 주 단위로 조합에 의해 제출되며 해당 직원의 다음 달 임금에서 공제된다. 

**급여 관리 애플리케이션**

평일에 한 번씩 실행되고 해당 직원에게 그날 임금을 지급한다.

이 시스템은 직원이 임금 받을 날짜를 입력 받아, 지정된 날짜 전에 마지막으로 임금을 받은 날부터 지정된 날짜까지의 임금을 계산한다. 

---

#### USE CASES

---

1. **새 직원 추가하기**
새로운 직원은 `AddEmp` 트랜잭션을 받는 것으로 추가된다. 
	```
	AddEmp <직원번호> "<이름>" "<주소>" H <시급>
	AddEmp <직원번호> "<이름>" "<주소>" S <월급>
	AddEmp <직원번호> "<이름>" "<주소>" C <월급> <수수료율>
	```
	트랜잭션 구조가 부적합하다면, 에러 메시지를 출력하고 아무 동작도 하지 않는다. 
	
2. **직원 삭제하기**
	`DelEmp` 트랜잭션을 받으면 직원을 삭제한다. 이 트랜잭션의 형식은 다음과 같다.
	```
	DelEmp <직원번호>
	```
	<직원번호> 필드가 올바르지 않거나 유효한 직원 레코드를 가리키지 않는다면, 에러메시지를 출력하고 아무 동작도 하지 않는다.
3. **출퇴근 카드 기록하기** `시간제 직원 관리`
	`TimeCard` 트랜잭션을 받으면 시스템은 출퇴근 카드 레코드를 하나 생성하고, 이것을 해당하는 직원 레코드에 연결한다. 
	```
	TimeCard <직원번호> <날짜> <시간>
	```
	선택된 직원이 시간제 직원이 아니라면 에러 메시지를 출력하고 더 이상의 동작은 취하지 않는다. 

	트랜잭션 구조가 올바르지 않다면 마찬가지로 에러 메시지를 출력하고 더 이상의 동작은 취하지 않는다. 
4. **판매 영수증 기록하기** `판매 수수료 직원 관리`
`SaleReceipt` 트랜잭션을 받으면 시스템은 새로운 판매 영수증 레코드를 하나 생성하고, 이를 해당 직원에 연결한다. 
	```
	SalesReceipt <직원번호> <날짜> <액수>
	```
	선택된 직원이 판매 수수료를 받지않는 직원이라면, 에러 메시지를 출력하고 더 이상의 동작은 취하지 않는다. 

	트랜잭션 구조가 올바르지 않다면 에러 메시지를 출력하고 더 이상의 동작은 취하지 않는다. 

5. **조합 공제액 기록하기** `조합원 관리`
	`ServiceCharge` 트랜잭션을 받으면 시스템은 공제액 레코드를 하나 생성하고, 이를 해당 조합원 레코드에 연결한다. 
	```
	ServiceCharge <직원번호> <액수>
	```
	트랜잭션의 형식이 올바르지 않거나 직원번호가 유효한 조합원이 아니라면, 에러 메시지를 출력한다.
6. **직원 정보 변경하기**
	`ChgEmp` 트랜잭션을 받으면 해당 직원 정보를 변경한다. 
	```
	ChgEmp <직원번호> Name <이름>
	ChgEmp <직원번호> Address <주소>
	...
	```
	이 트랜잭션의 형식에는 다양한 변형이 있을 수 있기 때문에 에러가 발생할 수 있는 형태도 다양하다. 
	예시로 올바르지 않은 직원 번호를 들 수 있다. 
7. **당일을 위한 급여 프로그램 실행하기**
	`Payday` 트랜잭션을 받으면, 해당 날짜에 임금을 받아야 할 직원을 모두 가져온다. 그리고 이들이 얼마의 액수를 받아야 하는지 결정하며 각각의 지급 방법에 따라 임금을 지급한다. 
	```
	Payday <날짜>
	```

---
### DESIGN PATTERNS

#### ***Command*** *Pattern*

> 커맨드(COMMAND) 패턴은 내가 가장 단순하면서도 세련된 것으로 보는 패턴이다. - *클린소프트웨어 p.199*

**UML Diagram**

![the image for Command](https://github.com/sangeui/Payroll-system/blob/master/Resources/Command.png)  
 
**Code Example**
```swift
protocol Command {
	func execute()
}
```

**Example-1**

![the image for Command](https://github.com/sangeui/Payroll-system/blob/master/Resources/CommandExample.png)

`Human` 객체는 `age` 값이 증가함에 따라 성장 단계를 의미하는 `growth` 값이 변경되고, 그에 맞는 행동을 한다. 
이때, `Human` 은 단순히 `Command` 의 `execute` 를 호출하기만 하면 된다. 

*Command_ActiveObject.playground-Command-Example1 참조*

**Example-2**

![the image for Command](https://github.com/sangeui/Payroll-system/blob/master/Resources/CommandExample2.png)

위와 같은 직원들의 데이터베이스를 관리하는 시스템을 작성하고 있다고 했을 때, 사용자들은 이 데이터베이스를 이용하여 새 직원을 추가하고, 기존 직원을 삭제하고, 직원의 속성을 변경하는 등의 작업을 할 수 있다. 

사용자가 새 직원을 추가해야 한다면, 직원 레코드 생성을 위한 모든 정보를 지정해야 한다. 시스템은 그 정보에 따라 동작하기 전에 그 정보가 올바른지 확인해야 하는데, 이때 커맨드 패턴이 사용될 수 있다. 

`command` 객체는 검증되지 않은 데이터를 위한 저장소 역할을 하고, 검증 메소드를 구현하며, 마지막으로 트랜잭션을 실행하는 메소드를 구현한다. 

```swift
protocol Transaction {
	func validate()
	func execute()
}
```

![the image for Command](https://github.com/sangeui/Payroll-system/blob/master/Resources/CommandExample3.png)

`AddEmployeeTransaction` 은 `Employee` 가 포함하고 있는 것과 같은 데이터 필드를 갖고 있으며 `PayClassification` 도 가진다.

`validate` 메소드를 통해 데이터가 올바른지 확인하고, 새 직원 추가 트랜잭션이므로 데이터베이스에 이미 해당하는 직원이 있는 건 아닌지 확인할 수도 있다. 

`execute` 메소드는 `validate` 를 통해 확인이 완료된 올바른 데이터를 사용해 데이터베이스를 갱신한다. 새로운 `Employee` 객체가 이 트랜잭션의 데이터들을 이용해 생성될 것이며, `PayClassification` 객체는 `Employee` 객체 내부로 옮겨지거나 복사된다. 

*Command_ActiveObject.playground-Command-Example2 참조*

---

#### ***Active Object*** *Pattern*

> 이 패턴은 역사가 아주 오래된 다중 제어 스레드(thread) 구현을 위한 기법이다. 이것은 여러 가지 형태로 수천 개의 산업 시스템에서 단순한 멀티태스킹(multitasking)의 핵심부가 되어왔다. 

**Example**

`Engine` 객체는 `Command` 객체의 연결 리스트를 유지한다. 사용자는 이 엔진에 새로운 명령을 추가할 수도 있고, `run()` 을 호출할 수도 있다. 

`run()` 은 단순히 각 명령을 실행하고 이를 제거하면서 연결 리스트를 훑어나가는 함수이다. 

```swift
class Engine {
	var itsCommands = LinkedList<Command>()
	func addCommand(_ command: Command) {
		itsCommands.append(command)
	}
	func run() {
		while (!itsCommands.isEmpty) {
			let command = itsCommand.first!
			itsCommands.pop()
			command.execute()
		}
	}
}
```

연결리스트 `itsCommands` 의 객체 중 하나가 자신을 복제하여 그 복제본을 다시 리스트에 넣는다면, `run()` 의 `while` 종료 조건인 비어 있는 연결리스트를 절대 충족하지 않으므로 `run()` 함수는 절대 종료되지 않는다. 

아래의 `SleepCommand` 를 보자. 이는 `Command` 프로토콜을 따른다. 

```swift
protocol Command {
	func execute()
}
class SleepCommand: Command {
	private var wakeupCommand: Command
	private var engine: Engine
	private var sleepTime = 0
	private var startTime = 0
	private var started = false

	init(delay: Int64, engine: Engine, command: Command) {
		self.sleepTime = delay
		self.engine = engine
		self.wakeupCommand = command
	}

	func execute() {
		// current(): 현재 시간을 `TimeStamp` 형태로 가져오는 커스텀 메소드
		let currentTime = Date().current()
		if started == false {
			started = true
			startTime = currentTime
			engine.addCommand(self)
		} else if currentTime - startTime < sleepTime {
			engine.addCommand(self)
		} else {
			engine.addCommand(wakeupCommand)
		}
	}
}
```

`SleepCommand` 는 실행이 되면 (`execute()`) 자신이 이전에 실행된 적이 있었는지 확인한다. 

- 실행된 적이 없다면, `currentTime` 을 시작 시간으로 기록하고 자신을 다시 `engine` 에 넣는다.
- 이전에 실행은 되었으나 `sleepTime` 만큼 지나지 않았다면, 자신을 다시 `engine` 에 넣는다.
- 이전에 실행 되었으며 `sleepTime` 이 지났다면, 이번에는 `engine` 에 자신이 아니라 `wakeupCommand` 를 넣는다. 

그러니까 `Engine` 의 입장에서는 `SleepCommand` 를 꺼내어 풀어주지만 정해진 시간이 지나지 않았다면 이 커맨드는 다시 들어오기 때문에, 계속 같은 `SleepCommand` 를 반복해서 실행하게 된다. 

위와 같은 방식은 어떤 `이벤트`를 기다리는 `멀티스레드` 프로그램을 흉내낸 것이다. 이런 스레드는 각 `Command` 인스턴스가 다음 `Command` 인스턴스 실행이 가능해지기 전에 완료되기 때문에, `RTC(run-to-completion)` 태스크라는 이름으로 알려져 있다. 

**Delay Typer Example**

`Engine` 과 `Sleep Timer` 를 활용해서 문자를 출력하는 프로그램을 작성한다. 

```swift
class DelayedTyper: Command {
	private static let engine = Engine()
	private static var stop = false

	private var delay: Int64
	private var character: Character
	// ...
	func start() {
		DelayedTyper.engine.addCommand(DelayedTyper(...))
		DelayedTyper.engine.addCommand(DelayedTyper(...))
		DelayedTyper.engine.addCommand(DelayedTyper(...))
		DelayedTyper.engine.addCommand(DelayedTyper(...))

		let stopCommand = Command(...)
		DelayedTyper.engine.addCommand(SleepCommand(20000, DelayedTyper.engine, stopCommand)
		DelayerTyper.engine.run()
	}
	// MARK: - 실행 메소드. 문자를 출력하고 `stop` 값에 따라 동작을 달리한다.
	func execute() {
		print(character)
		if stop == false { delayAndRepeat() } 
	}
	// MARK: - 본 클래스 각각의 객체가 가지는 지연 시간 이후 다시 자신을 실행한다.
	func delayAndRepeat() {
		DelayedTyper.engine.addCommand(SleepCommand(...))
	}
}
```

`start()` 를 호출하면 선언된 `DelayedTyper` 객체를 `Engine` 에 차례대로 넣는다. 마지막으로 `stopCommand` 를 넣고 엔진을 실행한다. 

우선 엔진의 `stopCommand` 앞에 위치한 모든 `DelayerTyper` 들이 실행된다. 이들 각각은 저마다의 `delayAndRepeat()` 를 호출한다. 이때 새롭게 만들어진 `SleepCommand` 는 엔진의 `stopCommand` 뒤에 추가된다. 

이 행동을 `stopCommand` 가 실행될 때까지 반복한다. `stopCommand` 가 실행되면 `stop` 변수의 값을 바꾸고, 이는 더이상 `delayAndRepeat()` 을 호출하지 않도록 한다. 

간단하게 말하면 `DelayedTyper` 는 문자를 출력하고 각자의 지연 시간 대기를 반복한다. 이후 `stopCommand` 가 실행되면 동작을 멈춘다.

실제로 실행을 해보면 출력 결과가 서로 다르게 나타나는데, 

**135711131151371113511131715...**
**135711131151371113511131713...**

위 두 결과에서 마지막 문자가 다르게 출력되었다.

이는 CPU 클록과 실제 시간이 완벽하게 동기화되지 않기 때문에 나오는 결과라고 한다. 이러한 비결정적(nondeterministric) 행위는 멀티스레드 시스템의 특징이다.

---

**CONCLUSION - Command & Active Object**

커맨트 패턴은 데이터베이스 트랜잭션, 멀티스레드 시스템 등 다양하게 사용될 수 있다. 
커맨트 패턴은 클래스보다는 함수를 강조하여 객체 지향 패러다임을 망친다고 생각되지만, 실제로는 아주 유용하게 쓰일 수 있다고 한다. 

---
