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

#### USE CASE

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

6. **조합 공제액 기록하기**
`조합원 관리`
7. **직원 정보 변경하기**
8. **당일을 위한 급여 프로그램 실행하기**
