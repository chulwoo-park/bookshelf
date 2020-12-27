# bookshelf

# 프로젝트 구조


프로젝트는 클린 아키텍쳐를 기반으로 구현했고, 패키지는 기능별로 분리되어 있습니다:

``` console
├── common
│   ├── exception
│   └── model
├── di
├── feature
│   ├── book
│   │   ├── data
│   │   ├── domain
│   │   └── presentation
│   └── note
│       ├── data
│       ├── domain
│       └── presentation
├── http
├── shared_preferences
└── ui
    ├── common
    ├── detail
    └── home
```

Flutter에선 안드로이드의 멀티 모듈 빌드와 같은 기능을 아직 제공하지 않고 있어, 각 기능 및 레이어를 별도의 모듈로 쪼개진 않았습니다.


# DI

주로 get_it을 사용하나 서드파티 패키지 사용에 대한 제약이 있어 InheritedWidget을 확장해 ServiceLocator를 구현했습니다.
UseCase 클래스 내에서 해당 클래스 상태를 변화시키는 상황이 없기 때문에 모두 싱글턴으로 제공하고 있습니다.

# 유즈케이스

제공된 문서를 기반으로 다음 유즈케이스를 정의했습니다:

[Search]
* SearchBookUseCase

[Detail Book]
* GetBookDetailUseCase
* AddNoteUseCase
* GetNotesUseCase


# feature/book

책 정보와 관련된 데이터는 캐싱된 데이터(SharedPreferences)를 우선 사용하고, 캐시 미스(CacheMissException)가 발생한 경우에만 원격 서버에서 데이터를 로드합니다(http).

이미지 정보는 NetworkImage를 커스터마이징 했고(CacheNetworkImage), isolate와 관련된 코드도 해당 클래스에서 확인할 수 있습니다.
로드된 이미지를 파일로 저장해 최대 용량 100MB를 가진 LRU 캐시로 관리하도록 했습니다.

이미지 캐시와 책 정보에 대한 메타 데이터는 SharedPreferences를 사용해 관리하고 있습니다.

# feature/note

노트와 관련된 데이터는 로컬로 관리합니다.(SharedPreferences)


# 모델 변환

각 레이어의 모델은 불필요한 경우 최대한 축소했고, 도메인 모델/API 응답 모델에 대해서만 구현을 진행했습니다.
API 응답 모델에 대한 json 파싱은 직접 진행했으나 보통 json_serializable을 사용합니다.(혹은 freezed)

# 네트워크 에러 처리

다음의 상황에 대해 처리했습니다:

* 네트워크 연결 안됨(SocketException)
* API 에러(200 외 코드)

HTTP 상태 코드에 대해 커스텀 에러 클래스를 일부 추가했으나, UI에선 크게 NetworkConnectivity/그 외 에러 두 상황만 처리하고 있습니다.

# UI

상태 관리 패키지로 BLoC을 사용했습니다.
UseCase 클래스를 State 모델로 매핑하는 형태로 구현하는 데 사용합니다.
view model(bloc)과 UI 클래스들 내에서 비즈니스 로직을 더 단순한 관점에서 볼 수 있어 선호합니다.


# 테스트

각 유즈케이스와 게이트웨이 영역(repository), BLoC에 대해서만 TDD로 테스트를 작성했습니다.

