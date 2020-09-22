/// 视频质量
enum TX_Enum_Type_VideoQuality {
  NONE,

  ///< 标清：采用 360 × 640 的分辨率
  VIDEO_QUALITY_STANDARD_DEFINITION,

  ///< 高清：采用 540 × 960 的分辨率
  VIDEO_QUALITY_HIGH_DEFINITION,

  ///< 超清：采用 720 × 1280 的分辨率
  VIDEO_QUALITY_SUPER_DEFINITION,

  ///< 蓝光：采用 1080 × 1920 的分辨率
  VIDEO_QUALITY_ULTRA_DEFINITION,

  ///< 连麦场景下的大主播使用
  VIDEO_QUALITY_LINKMIC_MAIN_PUBLISHER,

  ///< 连麦场景下的小主播（连麦的观众）使用
  VIDEO_QUALITY_LINKMIC_SUB_PUBLISHER,

  ///< 纯视频通话场景使用（已废弃）
  VIDEO_QUALITY_REALTIME_VIDEOCHAT,
}

/// 播放器类型
enum TX_Enum_PlayType {
  NONE,

  /// RTMP 直播
  PLAY_TYPE_LIVE_RTMP0,

  /// FLV 直播
  PLAY_TYPE_LIVE_FLV1,

  /// FLV 点播
  PLAY_TYPE_VOD_FLV,

  /// HLS 点播
  PLAY_TYPE_VOD_HLS,

  /// MP4点播
  PLAY_TYPE_VOD_MP4,

  /// RTMP 直播加速播放
  PLAY_TYPE_LIVE_RTMP_ACC,

  /// 本地视频文件
  PLAY_TYPE_LOCAL_VIDEO,
}
