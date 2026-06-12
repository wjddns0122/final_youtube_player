import 'package:flutter/material.dart';
import 'package:youtube_player_project/component/custom_youtube_player.dart';
import 'package:youtube_player_project/model/video_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 가장 기본 구조인 Scaffold 위젯으로 변환
    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검정으로
      /// 우선 body 부분에다가 유튜브 플레이어를 표시할 예정이므로 ppt와 지금 다르게 버젼이 업데이트 되어 유튜브 플레이어를 먼저 만들겠습니다.
      body: SafeArea(
        child: CustomYoutubePlayer(
          videoModel: VideoModel(
            id: 'p6E9R9qv1No',
            title:
                'Jason Derulo - Colors [Official Music Video] [Coca-Cola Anthem for the 2018 FIFA World Cup]',
          ),
        ),
      ),
    );
  }
}
