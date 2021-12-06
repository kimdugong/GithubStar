# Github Stars

Github API를 이용한 Github 사용자 즐겨찾기 앱

![screen shot](https://d.pr/i/G03uSF+)

## architecture

- RxSwift - MVVM

- CoreData

### Input Output protocol

protocol을 활용한 입출력 property 정의

### RxSwift를 이용한 비동기 프로그래밍

- 이벤트 기반의 비동기 프로그래밍

- 데이타 바이딩으로 view - viewModel간의 약한 결합도 유지

### Coredata를 활용한 persistent data

- CRUD기반 unit test 작성

## 향후 개선 사항

- DI framework를 이용하여 결합도가 낮고 테스트 가능하기 쉽게 변경

- Error 정의 후 Error handling

## 사용한 framework

### RxSwift

Reactive Programing을 위해 사용

### Moya

잘만들어진 Network Layer + test data, plugin등을 사용

### Kingfisher

이미지 캐싱을 위해 사용

### SnapKit

Autolayout 작성을 간편하게 사용 위해 사용

### Tabman

상단 Tabbar를 구현하기 위해 사용
