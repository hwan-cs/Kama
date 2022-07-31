# Kama ☮️
![alt text](https://user-images.githubusercontent.com/68496759/182043471-60065684-0be4-45f7-93ba-0bf1d770384d.png)

## 2022 1학기 K-Lab 프로젝트

장애인이 일상생활에 불편을 겪을 때 도움을 신청하고, 도움을 받을 수 있게 하는 앱, "카마" 입니다.


## 기능 🛠

- 회원가입 (헬퍼와 사용자로 구분, DB에 저장) 
- 로그인 (DB를 통해 정보 확인)
- 모든 사용자에게 똑같이 보이는 지도 마커 (DB사용)
- 도움 마커 클릭 시 팝업 시트 (사용자 구분에 따라 다른 화면)
- 도움 요청/수락 및 데드라인 지났을 시 만료됨
- 포인트 시스템 (칭호)
- 프로필 화면 (사진 설정 가능, 요청 목록 확인 가능)

## Tech 🧑🏻‍💻

- Firebase/Auth
- Firebase/Firestore
- Firebase/Analytics
- TweeTextField
- Google Maps 
- Google Places
- SwiftDate 
- DropDown

## 스크린샷 (일부만)

| 메인 화면 (1)   | 회원가입 화면       |  로그인 화면    |
| ------------- | ------------- | ------------- |
| ![alt text](https://user-images.githubusercontent.com/68496759/182044289-b2e516d2-a784-4069-9643-31794f5d64b4.png)  | ![alt text](https://user-images.githubusercontent.com/68496759/182044291-70f50b8c-7025-4b39-82c1-e17788dba357.png)  | ![alt text](https://user-images.githubusercontent.com/68496759/182044296-bf0c0d1d-1bee-4cef-89b6-a81147235b75.png)  |

| 메인 화면 (2)  | 마커 클릭 시 화면 | 마이페이지 |
| ------------- | ------------- | ------------- |
| ![alt text](https://user-images.githubusercontent.com/68496759/182044297-bac36cf1-7c05-4070-b651-5f1bf585cc95.png)  | ![alt text](https://user-images.githubusercontent.com/68496759/182044301-2629acba-895f-4f15-9980-168af604f12d.png)  | ![alt text](https://user-images.githubusercontent.com/68496759/182044303-4715b247-4939-4042-a995-292e3790ddaa.png) |

```Swift
var onDismissBlock : ((Bool) -> Void)?
self.onDismissBlock!(true)
```
