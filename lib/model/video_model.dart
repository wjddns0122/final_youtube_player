/// VideoModel 클래스: 동영상 정보를 저장하는 모델
class VideoModel {
  /// 동영상 ID: 고유한 식별자
  final String id;

  /// 동영상 제목: 동영상의 제목
  final String title;

  /// 동영상 설명 : 동영상의 설명문
  final String description;

  /// 생성자: VideoModel 인스턴스를 생성할 때 사용
  VideoModel({
    required this.id,
    required this.title,
    // 설명은 없을 수도 있기 때문에 빈 문자열로 두겠습니다
    this.description = '피파 월드컵 2018년도 공식 테마곡입니다.',
  });
}
