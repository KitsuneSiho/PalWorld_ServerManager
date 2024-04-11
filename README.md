# PSM(Palworld Server manager) script (lastest v.1.4.0)

여기저기에서 참조했는데, 링크를 못찾아서 출처는 나중에 쓰는거로 하고...
간단히말해서 터미널로 켜고 끌수 있는 스크립트입니다.

1.5엔 메모리 관리기능 추가예정!!


> 사용환경
- Ubuntu 22.- LTS 에서 작동 확인.
- Docker 로 서버가 운영되어야 합니다. 링크 나중에 올리기
- 크론탭(CronTab) 사용가능.


> 사용방법
- ./스크립트파일이름 명령어
- ex) ./server_manager start
- 백업을 .tar.gz 형태로 하면 효율적이겠지만 이상하게 압축파일 헤더손상이 일어나더군요..
그래서 범용성 쩌는 노압축 zip으로 백업시킵니다.

형식은 다음과 같습니다.

cd /백업할경로 && zip -r /백업한파일을_위치시킬곳/${TIMESTAMP}-palworld-saved.zip 백업대상과_그안에_들어있는_하위폴더들/

예를들어,

cd /home/user/Server/PalWorld/serverfile/palworld/Pal && zip -r /home/user/Server/PalWorld/backups/${TIMESTAMP}-palworld-saved.zip Saved/

경로를 이렇게 설정하면 "우선 /Pal 까지 진입 후, /backups 폴더에 Saved/ 폴더 통째로 현재시간-palworld-saved.zip 형태로 저장한다." 라는 뜻입니다.

조금 복잡하지만 원하는 범위를 원하는 곳에 저장시킬수 있어요!!


> 명령어
- start : 팰월드 docker container를 시작합니다.
- stop : 팰월드 docker container를 정지합니다.
- restart : 팰월드 서버를 정지후 백업하고, 다시 시작합니다.
- backup : 팰월드 서버 세이브파일을 백업합니다.


> 주의사항
- 크론탭 사용시 루트 패스워드를 입력해줘야합니다. 방법은 나중에 쓰기...
- 본 스크립트는 내가 쓸려고 만든거라 타 환경에서 작동을 보장하지 않습니다.
- 재시작 기능에 백업 기능이 포함되어 있습니다. 원치 않을경우 해당 코드 부분만 삭제하면 됩니다.


> 업데이트 내역
- V 1.0 최초릴리즈.
- V 1.2.1 백업기능 추가.
- v.1.4.0 재시작 기능 추가.
