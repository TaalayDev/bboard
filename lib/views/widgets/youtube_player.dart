import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../helpers/helper_functions.dart';

class YoutubePlayer extends StatelessWidget {
  const YoutubePlayer({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: YoutubePlayerController(
        initialVideoId: convertUrlToId(videoUrl),
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      ),
      aspectRatio: 16 / 9,
    );
  }
}
