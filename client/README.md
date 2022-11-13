# localstack_dashboard_client

local stack dashboard implemented with flutter + riverpod

fifo check

dau check 적용

db export

secure key export

리스트 조회후, attribute 싹다 조회해서 NotExistQueue라면, 자동으로 지우기 (단, attache는 남김)
refresh 누르면, 전부 재조회

삭제될 예정이라면, 보일때 (Deleting... 이라고 표시)

messageDeduplicationId 옵션에 따라 duplciate 수정하도록 개선

ddb에는 쿼리/스캔 숏컷넣기

flutter pub run build_runner build