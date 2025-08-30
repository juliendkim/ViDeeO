**Language / 언어**: [English](README.md) | [한국어](README.ko.md)

# ViDeeO

**ViDeeO**는 Flutter와 MPV를 기반으로 한 크로스 플랫폼 비디오 플레이어 앱입니다.

![Platform](https://img.shields.io/badge/Platform-Flutter-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 기능

### 🎬 **비디오 재생**
- MPV 기반 고품질 비디오 재생
- 하드웨어 가속 지원
- 다양한 비디오 포맷 지원

### 🎮 **직관적인 컨트롤**
- 재생/일시정지
- 10초 전/후 빠른 이동
- 드래그 가능한 프로그레스 바
- 실시간 볼륨 조절
- 자동 컨트롤 숨김/표시

### 📋 **플레이리스트 기능**
- **스마트 플레이리스트**: 비디오 선택 시 폴더 내 모든 비디오 파일 자동 로드
- **자동 정렬**: 파일명 기준 알파벳 순 정렬
- **토글 가능한 사이드바**: 화면 오른쪽에 슬라이드 패널
- **자동 다음 재생**: 현재 비디오 종료 시 다음 파일 자동 재생
- **원클릭 재생**: 플레이리스트에서 파일 클릭으로 즉시 재생
- **시각적 표시**: 현재 재생 중인 파일 하이라이트

### 🖱️ **편리한 파일 관리**
- 드래그 앤 드롭 지원
- 파일 선택기 통합
- 실시간 파일 유효성 검증

### 🖼️ **전체화면 및 창 관리**
- macOS 네이티브 전체화면 지원
- 마우스 기반 컨트롤 표시/숨김 (화면 하단 20% 영역)
- 자동 컨트롤 타임아웃 (3초)

### 📱 **멀티플랫폼 지원**
- macOS
- Windows
- Linux  
- iOS
- Android

### 🎨 **모던 UI**
- Material Design 3 기반
- 다크 테마 UI
- 부드러운 애니메이션
- 직관적인 아이콘

## 스크린샷

### 메인 화면
앱을 처음 실행하면 "ViDeeO" 로고와 함께 비디오 파일을 선택할 수 있는 버튼이 표시됩니다.

### 비디오 재생
비디오가 재생되는 동안 화면을 터치하면 컨트롤러가 나타나며, 3초 후 자동으로 숨겨집니다.

### 플레이리스트
상단 툴바의 플레이리스트 아이콘을 클릭하면 화면 오른쪽에 비디오 목록이 표시됩니다. 현재 재생 중인 파일은 파란색으로 하이라이트되며, 목록에서 다른 파일을 클릭하여 즉시 재생할 수 있습니다.

## 설치 및 실행

### 필요 요구사항

- Flutter 3.9.0 이상
- Dart 3.0.0 이상
- 플랫폼별 개발 환경 설정

### 설치

1. 저장소 클론
```bash
git clone https://github.com/juliendkim/ViDeeO.git
cd ViDeeO
```

2. 의존성 설치
```bash
flutter pub get
```

3. 앱 실행
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# iOS (시뮬레이터)
flutter run -d ios

# Android
flutter run -d android
```

## 사용법

### 기본 재생
1. **파일 선택**: "Select Video File" 버튼을 클릭하거나 비디오 파일을 드래그 앤 드롭
2. **재생 제어**: 화면을 클릭하여 컨트롤 패널 표시/숨김
3. **탐색**: 프로그레스 바를 드래그하여 원하는 위치로 이동

### 플레이리스트 기능
1. **플레이리스트 열기**: 상단 툴바의 📋 아이콘 클릭
2. **자동 로드**: 비디오 파일을 선택하면 해당 폴더의 모든 비디오 파일이 자동으로 플레이리스트에 추가됩니다
3. **수동 선택**: 플레이리스트에서 원하는 파일을 클릭하여 재생
4. **자동 재생**: 현재 비디오가 끝나면 다음 파일이 자동으로 재생됩니다

### 키보드 단축키
- **스페이스바**: 재생/일시정지
- **←/→**: 10초 전/후 이동
- **↑/↓**: 볼륨 조절

## 지원하는 비디오 형식

MPV의 강력한 디코딩 기능을 활용하여 다양한 비디오 형식을 지원합니다:

- MP4
- AVI
- MKV
- MOV
- WMV
- FLV
- WebM
- 그리고 더 많은 형식들...

## 사용된 기술

### Flutter 패키지
- `media_kit`: MPV 기반 미디어 재생 엔진
- `media_kit_video`: 비디오 렌더링 및 UI 컨트롤
- `media_kit_libs_video`: 플랫폼별 MPV 라이브러리
- `file_picker`: 파일 선택 다이얼로그
- `desktop_drop`: 드래그 앤 드롭 지원
- `path_provider`: 시스템 디렉토리 접근
- `window_manager`: macOS/Windows 창 관리 (전체화면, 타이틀바)
- `flutter_launcher_icons`: 크로스 플랫폼 앱 아이콘 생성

### 아키텍처
- **UI Layer**: Flutter Material Design 3
- **Media Layer**: MediaKit (libmpv)
- **Platform Layer**: 플랫폼별 네이티브 구현

## 개발

### 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점, MediaKit 초기화, window_manager 설정
├── config/
│   ├── app_config.dart         # 앱 설정과 상수들 (지원 파일 포맷, UI 설정)
│   └── app_theme.dart          # Material Design 3 다크 테마
├── services/
│   ├── file_service.dart       # 파일 처리 (선택, 드래그앤드롭, 폴더 스캔, 검증)
│   ├── video_player_service.dart # 비디오 재생 엔진 (MediaKit 래핑, 자동 다음 재생)
│   └── playlist_service.dart   # 플레이리스트 관리 (StreamController, 네비게이션)
├── widgets/
│   ├── video_player_controls.dart # 재생 컨트롤 (재생/일시정지, 볼륨, 프로그레스, 전체화면)
│   └── playlist_widget.dart    # 플레이리스트 UI (토글 사이드바, 현재 재생 하이라이트)
└── screens/
    └── video_player_screen.dart   # 메인 화면 (MouseRegion 기반 컨트롤 표시, 드래그앤드롭)

assets/
└── icons/
    ├── app_icon.png            # 앱 아이콘 (PNG, 모든 플랫폼용)
    └── app_icon.svg            # 앱 아이콘 소스 (벡터)

android/                         # Android 플랫폼 코드 및 생성된 아이콘
ios/                             # iOS 플랫폼 코드 및 생성된 아이콘  
macos/                           # macOS 플랫폼 코드 및 생성된 아이콘
windows/                         # Windows 플랫폼 코드 및 생성된 아이콘
linux/                           # Linux 플랫폼 코드
```

### 아키텍처 설계

#### 📁 **Config Layer**
- `AppConfig`: 앱 전역 설정, 상수, 지원 파일 포맷 정의
- `AppTheme`: Material Design 3 기반 테마 설정

#### 🛠️ **Service Layer**
- `FileService`: 파일 시스템 작업 (파일 선택, 폴더 스캔, 유효성 검증)
- `VideoPlayerService`: MPV 기반 비디오 재생 엔진 래핑, 자동 다음 재생 콜백
- `PlaylistService`: 플레이리스트 관리, 파일 네비게이션, 상태 스트리밍

#### 🎨 **Widget Layer**
- `VideoPlayerControls`: 재사용 가능한 미디어 컨트롤 컴포넌트
- `PlaylistWidget`: 토글 가능한 플레이리스트 사이드바, 애니메이션 포함
- 각 위젯은 단일 책임 원칙을 따라 설계

#### 📱 **Screen Layer**
- `VideoPlayerScreen`: 메인 비디오 재생 화면과 상태 관리
- 드래그 앤 드롭, 터치 제스처, 플레이리스트 토글 처리
- 자동 다음 재생 및 플레이리스트 연동

### 빌드

```bash
# 디버그 빌드
flutter build [platform] --debug

# 릴리즈 빌드
flutter build [platform] --release
```

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 기여

기여를 환영합니다! Pull Request를 보내기 전에 다음 사항들을 확인해 주세요:

1. 코드가 `flutter analyze`를 통과하는지 확인
2. 모든 테스트가 통과하는지 확인 (`flutter test`)
3. 새로운 기능에 대한 적절한 문서화

## 문제 신고

버그나 기능 요청이 있으시면 [Issues](https://github.com/juliendkim/ViDeeO/issues) 페이지에서 신고해 주세요.

## 감사의 말

- [MediaKit](https://github.com/media-kit/media-kit) - 훌륭한 Flutter 비디오 재생 솔루션을 제공해 주신 개발자분들께 감사드립니다.
- [MPV](https://mpv.io/) - 강력한 미디어 플레이어 엔진을 제공해 주신 MPV 팀에게 감사드립니다.

---

**ViDeeO** - *Simple, Powerful, Cross-platform Video Player*