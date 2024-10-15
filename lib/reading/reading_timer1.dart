import 'dart:async';
import 'package:flutter/material.dart';
import 'reading_timer2.dart';

class ReadingTimerPage1 extends StatefulWidget {
  @override
  _ReadingTimerPage1State createState() => _ReadingTimerPage1State();
}

class _ReadingTimerPage1State extends State<ReadingTimerPage1> {
  bool isRunning = false; // 타이머가 실행 중인지 여부
  Timer? _timer; // 타이머 객체
  Duration duration = Duration(seconds: 0); // 타이머 시간
  bool isScreenDimmed = false; // 화면이 어두워졌는지 여부
  Timer? _dimTimer; // 화면을 어둡게 하는 타이머

  // 타이머 시작
  void _startTimer() {
    setState(() {
      isRunning = true;
      _resetDimTimer(); // 타이머 시작 시 화면 어두워짐 타이머도 초기화
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        duration = Duration(seconds: duration.inSeconds + 1); // 타이머 1초씩 증가
      });
    });
  }

  // 타이머 일시정지
  void _pauseTimer() {
    setState(() {
      isRunning = false;
      _resetDimTimer(); // 버튼을 누르면 화면 어두워짐 타이머도 초기화
    });
    _timer?.cancel(); // 타이머 중지
  }

  // 타이머 정지 후 다음 페이지로 이동
  void _stopTimer() {
    _timer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingTimerPage2(duration: duration),
      ),
    );
  }

  // 시간 포맷을 00:00:00으로 맞추기 위한 함수
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // 화면을 어둡게 하는 타이머 설정
  void _startDimTimer() {
    _dimTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        isScreenDimmed = true; // 10초 후 화면을 어둡게
      });
    });
  }

  // 어두워짐 타이머를 리셋
  void _resetDimTimer() {
    _dimTimer?.cancel(); // 기존 타이머 취소
    setState(() {
      isScreenDimmed = false; // 화면이 밝아짐
    });
    _startDimTimer(); // 새 타이머 시작
  }

  @override
  void initState() {
    super.initState();
    _startDimTimer(); // 초기화 시 어두워짐 타이머 시작
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dimTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 사용자가 화면을 터치하면 타이머 리셋
      onTap: _resetDimTimer,
      child: Scaffold(
        appBar: AppBar(
          title: Text('리딩 타이머'),
          backgroundColor: Color(0xFFD9C6A5), // 상단 배경색
        ),
        body: Stack(
          children: [
            // 타이머 및 버튼 UI
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 도서명 텍스트
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '도서명 : 도서제목입니다',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 160),
                  // 타이머 텍스트
                  Text(
                    _formatDuration(duration), // 타이머 변수를 텍스트로 표시
                    style: TextStyle(
                      fontSize: 50,
                      color: Color(0xFF789C49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 60),
                  // 일시정지, 정지, 재생 버튼들
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 일시정지 버튼
                      if (isRunning)
                        IconButton(
                          icon: Icon(Icons.pause_circle_outlined, size: 50),
                          color: Color(0xFF789C49),
                          onPressed: _pauseTimer,
                        )
                      else
                      // 재생 버튼
                        IconButton(
                          icon: Icon(Icons.play_circle_filled, size: 50),
                          color: Color(0xFF789C49),
                          onPressed: _startTimer,
                        ),
                      SizedBox(width: 30),
                      // 정지 버튼
                      IconButton(
                        icon: Icon(Icons.stop_circle_outlined, size: 50),
                        color: Color(0xFF789C49),
                        onPressed: _stopTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 화면이 어두워지는 효과
            if (isScreenDimmed)
              Container(
                color: Colors.black.withOpacity(0.5), // 반투명 검정색으로 화면을 어둡게
              ),
          ],
        ),
      ),
    );
  }
}