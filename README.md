[![AutoCrypt CI](https://github.com/klioop/AutoCrypt-Assignment/actions/workflows/actions.yml/badge.svg)](https://github.com/klioop/AutoCrypt-Assignment/actions/workflows/actions.yml)

### Load a List of Vaccination Centers from Remote Server Use-cases

**Data**

* URL

**Use-Cases**

1. 시스템은 위 데이터로 서버에서 예방접종센터 데이터를 불러온다
2. 시스템은 데이터를 검증한다
3. 시스템은 오류 발생 시 오류 메세지를 전달한다
   - 연결(네트워크) 오류
   - 200 을 제외한 상태코드 오류
4. 시스템은 성공적으로 예방접종센터 리스트를 전달한다



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

⬜️ 뷰가 로드 되면 첫 페이지의 접종 센터 리스트가 보여진다
⬜️ 유저가 리로드 행동을 하면 다시 첫 페이지의 접종 센터 리스트가 보여진다
