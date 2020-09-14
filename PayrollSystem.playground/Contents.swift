import Foundation

// MARK: - 급여 관리 시스템의 기본 명세
// 이 시스템은 회사의 직원들 및 그들과 관련된 출퇴근 카드 같은 데이터로 구성되어 있다.
// 이 시스템은 각 직원에게 임금을 지급해야 하며, 직원들은 그들이 지정한 방식으로 정확한 시간에 정확한 액수를 지급받아야 한다.
// 또한 이들의 임금에서 다양한 공제가 가능해야 한다.

// MARK: - 시간제 직원 관리
/*
 어떤 직원은 시간제로 일한다. 이들은 직원 레코드의 한 필드인 시급에 따라 임금을 받는다.
 매일 날짜와 일한 시간을 기록한 출퇴근 카드를 제출하는데,
 - 하루에 8시간 이상 일하면 초과된 시간에 대해 1.5 배의 임금을 받게 된다.
 - 매주 금요일마다 임금을 받는다.
 */

// MARK: - 월급제 직원 관리
/*
 어떤 직원은 고정된 월급을 받으며, 매달 마지막 평일에 임금을 받는다.
 월급액수는 직원 레코드의 한 필드가 된다.
 
 - 월급을 받는 직원 중 일부는 별도로 판매량에 기반을 둔 수수료를 받는다.
 - 이들은 날짜와 판매량이 기록된 판매 영수증을 제출한다.
 - 수수료율은 직원 레코드의 한 필드가 된다.
 - 이들은 격주로 금요일마다 임금을 받는다.
 */

// MARK: - 임금 지급 방법
/*
 직원들은 임금 수령 받법을 선택한다.
 우편 주소로 급료 지급 수표를 받아볼 수도 있고, 급여 담당자에게 맡겨놓았다가 찾아갈 수도 있으며 은행 계좌로 입금 받을 수도 있다.
 */

// MARK: - 조합에 속한 직원
/*
 어떤 직원은 조합에 속한다. 이들의 직원 레코드에는 주당 조합비 비율을 나타내는 필드가 있으며, 이 조합비는 임금에서 공제된다.
 또한 조합은 가끔 조합원 개인에게 공제액을 부과할 수도 있다.
 이 공제액은 주 단위로 조합에 의해 제출되며, 해당 직원의 다음 달 임금에서 공제되어야 한다.
 */

// MARK: - 급여 관리 애플리케이션
/*
 평일에 한 번씩 실행되고 해당 직원에게 그날 임금을 지급한다.
 
 - 이 시스템은 직원이 임금을 받을 날짜를 입력받아,
 지정된 날짜 전에 마지막으로 임금을 받은 날부터 지정된 날짜까지의 임금을 계산한다.
 */
