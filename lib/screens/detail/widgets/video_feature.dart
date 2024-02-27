import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../common/config.dart' show kLoadingWidget;
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../routes/flux_navigate.dart';
import '../../../screens/detail/widgets/video_placeholder.dart';
import '../../../services/index.dart';

class FeatureVideoPlayer extends StatefulWidget {
  final String url;
  final bool? autoPlay;
  final double? aspectRatio;
  final bool enableTimeIndicator;
  final bool tapToPlayPause;
  final bool holdToPlayPause;
  final bool isSoundOn;
  final bool isPlaying;
  final bool isFullScreen;
  final bool doubleTapToFullScreen;
  final Duration? startAt;
  final bool showVolumeButton;
  final bool showFullScreenButton;

  const FeatureVideoPlayer(
    this.url, {
    Key? key,
    this.autoPlay,
    this.aspectRatio,
    this.enableTimeIndicator = false,
    this.tapToPlayPause = true,
    this.holdToPlayPause = false,
    this.isSoundOn = false,
    this.isPlaying = false,
    this.doubleTapToFullScreen = false,
    this.startAt,
    this.showVolumeButton = false,
    this.showFullScreenButton = false,
  }) : isFullScreen = false;

  const FeatureVideoPlayer.fullScreen(
    this.url, {
    Key? key,
    this.autoPlay,
    this.aspectRatio,
    this.enableTimeIndicator = false,
    this.tapToPlayPause = true,
    this.holdToPlayPause = false,
    this.isSoundOn = false,
    this.isPlaying = false,
    this.doubleTapToFullScreen = false,
    this.startAt,
    this.showVolumeButton = false,
    this.showFullScreenButton = false,
  }) : isFullScreen = true;

  @override
  State<FeatureVideoPlayer> createState() => _FeatureVideoPlayerState();
}

class _FeatureVideoPlayerState extends State<FeatureVideoPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool initialized = false;
  double? aspectRatio;
  bool isYoutube = false;
  bool isSoundOn = false;
  int lastTap = DateTime.now().millisecondsSinceEpoch;
  bool isVideoAvailable = true;

  late YoutubePlayerController _youtubeController;

  bool get showVideoPlaceholder => isDesktop || ServerConfig().isBuilder;

  Timer? _timer;

  void _cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _cancelTimer();

    _timer = Timer(const Duration(milliseconds: 100), () async {
      if (_controller != null && _controller!.value.isPlaying) {
        await _controller!.pause();
      }
      if ((await _youtubeController.playerState) == PlayerState.playing) {
        await _youtubeController.pauseVideo();
      }
    });
  }

  Future<void> initVideoController() async {
    final uri = Uri.parse(widget.url);
    _controller = VideoPlayerController.networkUrl(uri);
    await _controller!.initialize();
    await _controller!.setLooping(true).then(
      (_) {
        if (mounted) {
          setState(() {
            initialized = true;
            aspectRatio = widget.aspectRatio ?? _controller?.value.aspectRatio;
          });
          if (widget.autoPlay == true && widget.startAt == null) {
            _controller?.play();
            return;
          }
          if (widget.startAt != null && widget.isPlaying) {
            _controller?.play();
          } else {
            _controller?.pause();
          }
        }
      },
    );
    await _controller?.seekTo(widget.startAt ?? Duration.zero);
    setVolume(widget.isSoundOn);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (!showVideoPlaceholder) {
      if (widget.url.contains('youtu.be') || widget.url.contains('youtube')) {
        isYoutube = true;
        final videoId = YoutubePlayerController.convertUrlToId(widget.url);

        if (videoId == null) {
          isVideoAvailable = false;
          if (mounted) {
            setState(() {});
          }
          return;
        }

        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: widget.autoPlay ?? true,
          params: const YoutubePlayerParams(
            showControls: false,
            strictRelatedVideos: true,
            pointerEvents: PointerEvents.none,
            loop: true,
            showFullscreenButton: false,
            showVideoAnnotations: false,
            enableCaption: false,
          ),
        );
        return;
      }

      // Video player supports web version but I still disable it
      initVideoController();
      _controller?.addListener(_listener);
    }
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  void setVolume(bool value) {
    if (mounted) {
      setState(() {
        isSoundOn = value;
      });
    }

    isSoundOn ? _controller?.setVolume(1.0) : _controller?.setVolume(0.0);
  }

  void setIsPlaying(bool status) {
    status == true ? _controller?.play() : _controller?.pause();
  }

  @override
  void dispose() {
    if (!isYoutube) {
      _controller?.removeListener(_listener);
      _controller?.dispose();
    } else {
      _youtubeController.close();
    }
    WidgetsBinding.instance.removeObserver(this);
    _cancelTimer();
    super.dispose();
  }

  void updateStatusBarColor() {
    // If fullscreen video mode, always set light status bar
    widget.isFullScreen == true ||
            Theme.of(context).brightness == Brightness.dark
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void didChangeDependencies() {
    updateStatusBarColor();
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBarColor();
    }
  }

  Widget playPauseButton(bool isPlaying) {
    return isPlaying
        ? const SizedBox.shrink()
        : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                CupertinoIcons.play_arrow_solid,
                color: Colors.white,
                size: 50.0,
                semanticLabel: 'Play',
              ),
            ),
          );
  }

  void updateVideoStatus() {
    if (widget.holdToPlayPause == false) {
      _controller!.value.isPlaying ? _controller?.pause() : _controller?.play();
    }
  }

  void onTapVolume() {
    if (mounted) {
      setState(() {
        isSoundOn = !isSoundOn;
        // If the sound button is pressed, the video widget is also pressed (change isPlaying value)
        updateVideoStatus();
        isSoundOn ? _controller?.setVolume(1.0) : _controller?.setVolume(0.0);
      });
    }
  }

  void onTapFullScreen() async {
    // If  fullScreen button is pressed, the video widget is also pressed (change isPlaying value)
    updateVideoStatus();

    final previousStatus = await FluxNavigate.push(
      MaterialPageRoute(
        builder: (_) => FeatureVideoPlayer.fullScreen(
          widget.url,
          isSoundOn: isSoundOn,
          isPlaying: _controller!.value.isPlaying,
          startAt: _controller!.value.position,
          aspectRatio: widget.aspectRatio,
          autoPlay: widget.autoPlay,
          enableTimeIndicator: widget.enableTimeIndicator,
          doubleTapToFullScreen: widget.doubleTapToFullScreen,
          showVolumeButton: widget.showVolumeButton,
          showFullScreenButton: widget.showFullScreenButton,
          holdToPlayPause: widget.holdToPlayPause,
          tapToPlayPause: widget.tapToPlayPause,
        ),
      ),
    );
    if (previousStatus != null) {
      setIsPlaying(previousStatus[0] ?? false);
      setVolume(previousStatus[2] ?? false);
      await _controller!.seekTo(previousStatus[1] ?? Duration.zero);
      updateStatusBarColor();
    }
  }

  void onTapExitFullScreen() {
    // If the exit fullScreen button is pressed, the video widget is also pressed (change isPlaying value)
    updateVideoStatus();
    Navigator.pop(context,
        [_controller?.value.isPlaying, _controller?.value.position, isSoundOn]);
  }

  @override
  Widget build(BuildContext context) {
    if (showVideoPlaceholder) {
      return const VideoPlaceholder();
    }

    if (!isVideoAvailable) {
      return VideoPlaceholder(message: S.of(context).canNotPlayVideo);
    }

    if (!isYoutube) {
      if (initialized && _controller != null) {
        return WillPopScope(
          onWillPop: () async {
            Theme.of(context).brightness == Brightness.dark
                ? SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.light)
                : SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.dark);
            return true;
          },
          child: VisibilityDetector(
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 0) {
                _controller?.pause();
              }
            },
            key: ValueKey('mp4_player_iframe-${widget.url}'),
            child: Container(
              color: widget.isFullScreen ? Colors.black : Colors.transparent,
              child: Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio ?? _controller!.value.aspectRatio,
                  child: Listener(
                    onPointerDown: (_) {
                      if (widget.holdToPlayPause) {
                        _startTimer();
                      }
                    },
                    onPointerUp: (_) {
                      var now = DateTime.now().millisecondsSinceEpoch;
                      if (widget.doubleTapToFullScreen) {
                        // https://api.flutter.dev/flutter/gestures/kDoubleTapTimeout-constant.html
                        if (now - lastTap < 300) {
                          _cancelTimer();
                          lastTap = now;
                          if (!widget.isFullScreen) {
                            onTapFullScreen();
                          } else {
                            onTapExitFullScreen();
                          }
                          return;
                        }
                      }
                      if (widget.holdToPlayPause) {
                        _cancelTimer();
                        _controller!.play();
                      }
                      if (widget.tapToPlayPause) {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      }
                      lastTap = now;
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'video',
                          transitionOnUserGestures: true,
                          child: VideoPlayer(_controller!),
                        ),
                        if (widget.tapToPlayPause)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 50),
                            reverseDuration: const Duration(milliseconds: 200),
                            child:
                                playPauseButton(_controller!.value.isPlaying),
                          ),
                        if (widget.enableTimeIndicator)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VideoProgressIndicator(_controller!,
                                allowScrubbing: true),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              widget.showVolumeButton
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: onTapVolume,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Icon(
                                          isSoundOn
                                              ? Icons.volume_up
                                              : Icons.volume_off,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.showFullScreenButton
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: widget.isFullScreen
                                          ? onTapExitFullScreen
                                          : onTapFullScreen,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Icon(
                                          widget.isFullScreen
                                              ? Icons.fullscreen_exit
                                              : Icons.fullscreen,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

      return Container(
        height: MediaQuery.of(context).size.width * 0.8,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: kLoadingWidget(context),
        ),
      );
    }

    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          _youtubeController.pauseVideo();
        }
      },
      key: ValueKey('youtube_player_iframe-${widget.url}'),
      child: Listener(
        onPointerDown: (_) {
          if (widget.holdToPlayPause) {
            _startTimer();
          }
        },
        onPointerUp: (_) async {
          if (widget.holdToPlayPause) {
            _cancelTimer();
            await _youtubeController.playVideo();
          }
          if (widget.tapToPlayPause) {
            var playerState = await _youtubeController.playerState;
            if (playerState == PlayerState.playing) {
              await _youtubeController.pauseVideo();
            } else {
              await _youtubeController.playVideo();
            }
          }
        },
        child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: YoutubePlayer(
                controller: _youtubeController,
                aspectRatio: aspectRatio ?? 16 / 9,
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width,
            child: YoutubePlayerControllerProvider(
              controller: _youtubeController,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: YoutubePlayer(
                      controller: _youtubeController,
                      aspectRatio: aspectRatio ?? 16 / 9,
                    ),
                  ),
                  if (widget.tapToPlayPause)
                    Positioned.fill(
                      child: YoutubeValueBuilder(
                        builder: (context, value) {
                          return playPauseButton(
                              value.playerState == PlayerState.playing);
                        },
                      ),
                    ),
                  if (widget.enableTimeIndicator)
                    const Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: VideoPositionSeeker(),
                    )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return StreamBuilder<Duration>(
      // fixme: getCurrentPositionStream
      // stream: context.ytController.getCurrentPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final position = snapshot.data?.inSeconds ?? 0;
        final duration = context.ytController.metadata.duration.inSeconds;

        value = position == 0 || duration == 0 ? 0 : position / duration;

        return StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              activeColor: const Color.fromRGBO(255, 0, 0, 0.7),
              value: value,
              onChanged: (positionFraction) {
                value = positionFraction;
                setState(() {});

                context.ytController.seekTo(
                  seconds: (value * duration).toDouble(),
                  allowSeekAhead: true,
                );
              },
              min: 0,
              max: 1,
            );
          },
        );
      },
      stream: null,
    );
  }
}
