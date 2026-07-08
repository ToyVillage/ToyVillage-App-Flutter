# toy_village_app

토이빌리지 모바일 앱

## 환경 설정

- `lib/core/config/app_env.dart` : 인증 자격 증명 포함, gitignore 대상 (없으면 빌드/로그인 실패)
- 최초 클론 후 예제 복사 필요

```bash
cp lib/core/config/app_env.example.dart lib/core/config/app_env.dart
```

- 복사 후 값 설정
  - `baseUrl` : API 서버 주소
  - `adminEmail` : 관리자 이메일
  - `adminPassword` : 관리자 비밀번호
