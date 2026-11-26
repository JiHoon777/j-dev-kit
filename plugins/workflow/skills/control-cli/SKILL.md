---
name: control-cli
description: "바깥 서비스 없이 대화형 CLI 나 TUI 를 몰고, 들여다보고, 프로파일할 로컬 하네스를 만들거나 맞출 때. CLI UX 확인, 시작 시간 회귀, 메모리 누수, 멈춤, 프롬프트 흐름, 터미널 데모에 쓴다."
disable-model-invocation: true
---

# Control CLI

> 원문: `cursor/plugins`의 `cursor-team-kit/skills/control-cli/SKILL.md` (MIT, Cursor). Cursor 이름을 Claude Code 것으로 바꾸고 가져오지 않은 스킬을 가리키는 줄을 뺐다.

**언제:** 바깥 서비스 없이 대화형 CLI 나 TUI 를 몰고, 들여다보고, 프로파일할 로컬 하네스를 만들거나 맞출 때. CLI UX 확인, 시작 시간 회귀, 메모리 누수, 멈춤, 프롬프트 흐름, 터미널 데모에 쓴다.

대화형 CLI 를 손으로 찔러 보지 말고 되풀이할 수 있는 로컬 하네스로 돌린다. 저장소에 테스트 하네스나 데모 하네스가 있으면 그것부터 다시 쓴다. 없으면 표준 로컬 도구로 임시 하네스를 짠다.

## 어디에 쓰나

- 결정적인 입력으로 CLI/TUI 버그를 재현한다.
- 키보드 흐름, 프롬프트, 인터럽트, 크기 조절 동작, 터미널 배치를 검증한다.
- 버그 수정의 전후 기록(transcript)을 뜬다.
- 시작 시간, 느린 동작, 멈춤, 메모리 증가를 프로파일한다.
- 출력을 설명하기보다 보여 주는 편이 쉬울 때 짧은 터미널 데모를 녹화한다.

## 하네스 반복

1. 시험할 명령과, 재현되는 가장 작은 작업 공간을 정한다.
2. 이미 있는 로컬 하네스를 찾는다: 패키지 스크립트, e2e 테스트, 데모 녹화기, expect 스크립트, PTY 헬퍼.
3. 하네스가 없으면 결정적인 환경 변수를 준 격리된 터미널 세션에서 CLI 를 띄운다.
4. 상호작용하기 전에 지금 화면을 뜬다.
5. 동작을 한 번에 하나씩 보낸다: 글자, Enter, 화살표, Escape, Ctrl-C, 크기 조절.
6. 다음 동작 전에 구체적인 화면 패턴이나 프롬프트를 기다린다.
7. 기록과 프로파일 결과물을 저장한다.
8. 세션을 깨끗이 끝낸다.

## 하네스 선택지

- 저장소의 하네스: 저장소에 들어 있는 스크립트를 먼저 쓴다. 앱의 시작 방법, 환경, 프롬프트를 알고 있다.
- `tmux`: 관리되는 세션, `capture-pane`, `send-keys`, 붙기/떼기.
- PTY 프로브: tmux 를 쓸 수 없으면 짧은 Python, Node, Expect 스크립트를 쓴다.
- 런타임 인스펙터: CPU 프로파일, 힙 스냅샷, 실행 중 평가에는 Node 나 Bun 인스펙터를 쓴다.
- 터미널 녹화기: 사용자가 데모를 요청하면 저장소의 데모 도구나 asciinema 호환 도구를 쓴다.

## 최소 tmux 하네스

```bash
SESSION="cli-harness-$(date +%s)"
tmux new-session -d -s "$SESSION" -- <command-under-test>
tmux capture-pane -pt "$SESSION"
tmux send-keys -t "$SESSION" "help" Enter
tmux capture-pane -pt "$SESSION"
tmux kill-session -t "$SESSION"
```

Node CLI 면:

```bash
NODE_OPTIONS="--inspect=127.0.0.1:0" tmux new-session -d -s "$SESSION" -- <node-cli-command>
```

터미널 출력에서 인스펙터 URL 을 찾고, 프로파일이 필요하면 Chrome DevTools 호환 도구를 쓴다.

## 최소 PTY 하네스

tmux 도 데모 하네스도 없는 저장소에서 결정적인 기다림이 필요하면 PTY 스크립트를 쓴다. 사용자가 다시 쓸 테스트로 넣어 달라고 하지 않으면 임시로 둔다.

```python
import os
import pty
import select
import subprocess
import time

master_fd, slave_fd = pty.openpty()
proc = subprocess.Popen(
    ["<command>", "<arg>"],
    stdin=slave_fd,
    stdout=slave_fd,
    stderr=slave_fd,
    close_fds=True,
)
os.close(slave_fd)

deadline = time.time() + 30
buffer = b""
while time.time() < deadline:
    ready, _, _ = select.select([master_fd], [], [], 0.25)
    if not ready:
        continue
    chunk = os.read(master_fd, 4096)
    buffer += chunk
    if b"<ready text>" in buffer:
        os.write(master_fd, b"help\n")
        break

print(buffer.decode(errors="replace"))
proc.terminate()
os.close(master_fd)
```

CLI 에 더 풍부한 터미널 제어가 필요하면 `pty.fork()`나 이미 있는 PTY 라이브러리를 쓴다.

## 프로파일 방법

- 시작 시간 회귀: 같은 기계, 환경, 명령으로 기준선과 변경 뒤의 시작 시간을 잰다.
- 느린 동작: CPU 프로파일을 시작하고, 그 동작을 하고, 프로파일을 멈추고, 자체 시간(self-time)이 큰 함수들을 비교한다.
- 메모리 누수: 할 수 있으면 GC 를 강제하고, 힙 스냅샷을 뜨고, 그 동작을 여러 번 되풀이하고, 다시 GC 를 강제하고, 스냅샷을 한 번 더 뜬다.
- 멈춤: 인터럽트하기 전에 화면, 활성 핸들/자원, 스택/CPU 샘플을 뜬다.

## 지킬 것

- sleep 보다 결정적인 기다림을 쓴다. sleep 을 써야 하면 이유를 설명한다.
- 제어하는 세션에 자격 증명이나 파괴적인 명령을 보내지 않는다.
- 저장소에 테스트 하네스나 데모 하네스가 이미 있지 않으면 하네스는 `/tmp`에 둔다.
- 다른 저장소의 경로를 하드코딩하지 않는다. 명령을 지금 저장소의 스크립트와 런타임에 맞춘다.
- 사용자가 남겨 달라고 하지 않으면 tmux 세션, 임시 폴더, 인스펙터 프로세스, 데모 결과물을 정리한다.
