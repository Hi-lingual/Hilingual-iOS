# 하이링구얼 Hilingual

**🗓 프로젝트 기간: 2025.7.7 ~ 2025.7.19**

서울 도심 주요 집회 장소의 **실시간 혼잡도**와 **교통 통제 정보**를 제공하는 Android 애플리케이션입니다.

## 📌 주요 기능
- **영어 일기 주제 제공**: 매일 영어·한글로 구성된 작문 주제를 제공하여 일기 쓰기를 도와줍니다.  
- **일기 작성 및 기록 관리**: 선택한 날짜에 영어 일기를 작성하고, 이전 작성 내용을 다시 확인할 수 있습니다.  
- **작성 현황 캘린더**: 한 달 동안의 일기 작성 여부를 캘린더에서 직관적으로 확인할 수 있습니다.  
- **마이페이지 기능 제공**: 총 작성 수, 연속 작성 일수 등의 통계를 통해 나만의 영어 루틴을 시각화합니다.


## 👩‍💻 Front-End 팀원

<table>
  <tbody>
    <tr>
      <td align="center">
        <a href="https://github.com/hye0njuoo">
          <img src="https://github.com/user-attachments/assets/14753aa7-00a4-4c9c-9d62-fda88ec4cfc9" width="250px;" alt="hye0njuoo 프로필 사진"/>
          <br /><span style="font-size: 1.5em; font-weight: bold;">성현주</span>
        </a>
        <br />iOS LEAD
      </td>
      <td align="center">
        <a href="https://github.com/hyeyeonie">
          <img src="https://github.com/user-attachments/assets/ea2ccdba-9a59-4198-a128-9af6a5825fd5" width="250px;" alt="hyeyeonie 프로필 사진"/>
          <br /><span style="font-size: 1.5em; font-weight: bold;">신혜연</span>
        </a>
        <br />iOS MEMBER
      </td>
      <td align="center">
        <a href="https://github.com/jjwm10625">
          <img src="https://github.com/user-attachments/assets/4f15b91a-ac89-42a5-bdb6-4f9dbb03a05a" width="250px;" alt="jjwm10625 프로필 사진"/>
  <br /><span style="font-size: 1.5em; font-weight: bold;">조영서</span>
        </a>
        <br />iOS MEMBER
      </td>
      <td align="center">
        <a href="https://github.com/jjwm10625">
          <img src="https://github.com/user-attachments/assets/7cca1162-9d36-4db0-b118-412ea116c886" width="250px;" alt="jjwm10625 프로필 사진"/>
          <br /><span style="font-size: 1.5em; font-weight: bold;">진소은</span>
        </a>
        <br />iOS MEMBER
      </td>
    </tr>
  </tbody>
</table>

## 🛠 기술 스택
- **언어**: Swift
- **프레임워크**: UiKit
- **아키텍처**: 클린 아키텍처 (Clean Architecture), MVVM 패턴
- **버전 관리**: Git, GitHub

## 📌 프로젝트 소개
| <img src="https://github.com/user-attachments/assets/479fe920-1691-4773-ab9b-783751544331"/> | <img src="https://github.com/user-attachments/assets/d178be92-e0d7-4d5e-bd17-bbfdb58fadb7"/> | <img src="https://github.com/user-attachments/assets/8c79d35a-19ce-49dd-b236-06f73970fff7"/> |
|:---------:|:--------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------:|
| 앱 실행 시 로고 및 초기 로딩 화면 |                                     서울 도심 지도와 실시간 혼잡도 제공                                     |                                     특정 지역 선택 시 혼잡도 정보 표시                                     |

| <img src="https://github.com/user-attachments/assets/63f1881a-18a0-4dcc-b257-3050820ab602"/> | <img src="https://github.com/user-attachments/assets/93c059b1-cc61-4c58-8353-0012e5d4e7a8"/> | <img src="https://github.com/user-attachments/assets/790b4194-5199-4be2-866f-64e54f718fd0"/> |
|:--------------------------------------------------------------------------------------------:|:---------:|:--------------------------------------------------------------------------------------------:|
|                                       선택된 교통 통제 정보 표시                                        | 선택된 지역의 상세 정보 및 실시간 날씨 제공 |                                         날짜별 집회 일정 제공                                         |



## 📂 프로젝트 구조
```
📦 CrowdZero-Android
│── 📁 app (Presentation Layer)
│   ├── 📁 di 
│   ├── 📁 main 
│   ├── 📁 navigation 
│
│── 📁 core (Core Layer)
│   ├── 📁 designsystem 
│   │   ├── 📁 component
│   │   └── 📁 theme
│   ├── 📁 extension 
│   ├── 📁 navigation 
│   ├── 📁 state 
│   ├── 📁 type
│   ├── 📁 util 
│
│── 📁 data (Data Layer)
│   ├── 📁 datasource 
│   ├── 📁 datasourceimpl 
│   ├── 📁 dto 
│   │   ├── 📁 request
│   │   └── 📁 response
│   ├── 📁 mapper 
│   ├── 📁 repositoryimpl 
│   ├── 📁 service
│
│── 📁 domain (Domain Layer)
│   ├── 📁 entity 
│   ├── 📁 repository 
│
│── 📁 feature (Feature Modules)
│   ├── 📁 calendar
│   ├── 📁 detail 
│   ├── 📁 map 
│
└── 📄 build.gradle.kts
```
