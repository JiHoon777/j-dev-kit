---
type: llm
focus: trace
weight: 1
---

서베이가 쓴 보고서(기록의 `.claude/.local/reports/` Write 호출 내용. 쓰기가 막혔으면 마지막 메시지의 후보 표)를 본다. 후보마다 근거의 출처(URL 이나 `file:line`)가 있고, URL 근거마다 원문을 직접 읽었는지 검색 요약만 봤는지 표시(예: [직접]/[검색])가 있으면 PASS. 후보가 하나도 없거나, 출처가 없는 후보가 있거나, URL 근거에 그 표시가 없으면 FAIL. 표현과 형식은 따지지 않는다.
