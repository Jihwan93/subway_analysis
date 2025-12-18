# Subway Commute Pattern Analysis (SQL)

## 프로젝트 개요
본 프로젝트는 지하철 시간대별 승하차 데이터를 SQL로 분석하여  
각 지하철역의 통행 패턴을 기반으로 주거지 / 업무지 특성을 도출하는 것을 목표로 한다.

Python을 이용해 전처리된 데이터를 MySQL에 적재한 후,  
SQL 쿼리만을 사용해 집계, 파생 지표 생성, 분석을 수행하였다.

## 데이터 개요
- 데이터 출처: 서울시 지하철 시간대별 승하차 인원 데이터
- 데이터 형태: CSV
- 분석 단위: 지하철역 × 시간대

## 주요 컬럼
- `usage_month` : 사용월
- `line` : 호선명
- `station` : 지하철역명
- `hour` : 시간대
- `on_cnt` : 승차 인원
- `off_cnt` : 하차 인원

---SQL 작업---

##  테이블 구조
`
CREATE TABLE subway_flow (
  usage_month INT,
  line VARCHAR(10),
  station VARCHAR(50),
  hour INT,
  on_cnt INT,
  off_cnt INT
);
`

## 데이터 적제 확인
`
DESCRIBE subway_flow;
SELECT COUNT(*) FROM subway_flow;
`

## 시간대별 승/하차 집
`
SELECT
    station,
    SUM(CASE WHEN hour = 8 THEN off_cnt ELSE 0 END) AS morning_off,
    SUM(CASE WHEN hour = 18 THEN on_cnt ELSE 0 END) AS evening_on
FROM subway_flow
GROUP BY station;
`

## 출근 지수 계산을 위한 View 생성
`
CREATE VIEW commute_summary AS
SELECT
    station,
    SUM(CASE WHEN hour = 8 THEN off_cnt ELSE 0 END) AS morning_off,
    SUM(CASE WHEN hour = 18 THEN on_cnt ELSE 0 END) AS evening_on
FROM subway_flow
GROUP BY station;
`

## 데이터 대상 여부 확인
`
SELECT *
FROM commute_summary
WHERE evening_on = 0;
`

## 출근 지수 계산
`
SELECT
    station,
    morning_off,
    evening_on,
    morning_off / evening_on AS commute_index
FROM commute_summary
ORDER BY commute_index DESC;
`

---Python 작업--- (업데이트 예정)


