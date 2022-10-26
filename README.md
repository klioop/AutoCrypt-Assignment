[![AutoCrypt CI](https://github.com/klioop/AutoCrypt-Assignment/actions/workflows/actions.yml/badge.svg)](https://github.com/klioop/AutoCrypt-Assignment/actions/workflows/actions.yml)

### Load a List of Vaccination Centers from Remote Server Use-Case

**Data**

* URL

**Use-Case**

1. 시스템은 위 데이터로 서버에서 예방접종센터 데이터를 불러온다
2. 시스템은 데이터를 검증한다
3. 시스템은 오류 발생 시 오류 메세지를 전달한다
   - 연결(네트워크) 오류
   - 200 을 제외한 상태코드 오류
   - 상태코드는 200 이지만 invalid data 를 받은 경우 오류
4. 시스템은 성공적으로 예방접종센터 리스트를 전달한다



### Request Location Service Authorization Use-Case

**Use-Case**

1. 시스템은 start 을 실행한다
2. 위치 권한 요청 상태에 따라 다음의 행동을 한다:
   - denied 상태면 permissionRequired 메세지를 전달한다
   - restricted 상태면 locationServiceDisabled 메세지를 전달한다
   - whenInUse, always usage 상태면 permission 메세지를 전달한다
   - notDetermined 상태면 location manager 에게 requestWhenInUseAuthorization 을 말한다
   - 나머지는 unknown 메세지를 전달한다



### Model

**VaccinationCenter**

* id: CenterID
* name: String
* facilityN ame: String
* address: String
* lat: String
* lng: String
* updatedAt: String

**CenterID**

* let id: Int



### UX Goals - Scene for a List of Vaccination Centers

✅ 뷰가 로드 되면 첫 페이지의 접종 센터 리스트가 보여진다

✅ 접종 센터 리스트가 로드 되는 동안 로딩인디케이터가 보여진다

✅ 유저가 리로드 행동을 하면 다시 첫 페이지의 접종 센터 리스트만 보여진다

✅ 유저가 다음 페이지를 로드 하면 다음 페이지의 접종 센터 리스트가 보여진다
