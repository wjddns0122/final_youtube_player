import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_project/model/video_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CustomYoutubePlayer extends StatefulWidget {
  // 이곳에서 VideoModel을 받습니다
  final VideoModel videoModel;
  // required parameter로 viewModel을 무조건 필요하기때문에 비디오 모델을 미리 받습니다.
  const CustomYoutubePlayer({super.key, required this.videoModel});

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController?
  controller; // 최대한 ppt 를 따라하기 위해 controller 변수를 nullable로 받습니다.

  String _summary = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoModel.id,
    );

    // 화면 시작 시 AI 요약 가져오기 시도
    _fetchAISummary();
  }

  Future<void> _fetchAISummary() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null ||
        apiKey.isEmpty ||
        apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      setState(() {
        _errorMessage = '프로젝트 루트의 .env 파일에 GEMINI_API_KEY를 설정해 주세요.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash-lite',
        apiKey: apiKey,
      );

      final prompt =
          '''
다음 유튜브 영상의 제목과 설명을 읽고 핵심 내용을 요약해 주세요:

제목: ${widget.videoModel.title}
설명: ${widget.videoModel.description}

요약 가이드라인:
- 영상의 주제와 중요한 포인트를 한국어로 깔끔하게 정리해 주세요.
- 가독성을 높이기 위해 문단이나 글머리 기호(bullet points)와 적절한 이모지를 사용해 주세요.
- 인사말이나 분석 절차 같은 불필요한 서론/결론은 생략하고 요약 본문만 출력해 주세요.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      setState(() {
        _summary = response.text ?? '요약을 생성하지 못했습니다.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'AI 요약을 가져오는 중 오류가 발생했습니다.\n인터넷 연결 및 API 키를 확인해 주세요.';
        _isLoading = false;
      });
    }
  }

  /// 나머지 UI 부분 설계
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 유튜브 플레이어 위젯
        YoutubePlayer(
          controller: controller!,
        ), // 위에서 설정한 controller를 그대로 사용하겠다 -> 뒤에 '!'는 위험하긴 하지만 절대로 Null이 안들어온다는 뜻입니다.
        const SizedBox(height: 16),
        // 스크롤이 가능하도록 Expanded 와 SingleChildScrollView 배치
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.videoModel.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.videoModel.description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                _buildSummaryCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.amberAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'AI 요약 노트',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (!_isLoading && _errorMessage == null && _summary.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey, size: 18),
                  onPressed: _fetchAISummary,
                  tooltip: '요약 새로고침',
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.amberAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'AI가 영상을 열심히 분석하고 있습니다...',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: [
                  Icon(
                    _errorMessage!.contains('.env')
                        ? Icons.vpn_key
                        : Icons.error_outline,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _fetchAISummary,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('다시 시도'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (_summary.isNotEmpty)
            Text(
              _summary,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.6,
              ),
            )
          else
            const Text(
              '요약 정보가 없습니다.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
