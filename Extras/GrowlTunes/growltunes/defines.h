#define StateStopped iTunesEPlSStopped
#define StatePlaying iTunesEPlSPlaying
#define StatePaused iTunesEPlSPaused
#define StateFastForward iTunesEPlSFastForwarding
#define StateRewind iTunesEPlSRewinding

#define RENOTIFY_STREAM_KEY @"ReNotifyOnStreamingTrackChange"

#define ITUNES_BUNDLE_ID @"com.apple.iTunes"
#define PLAYER_INFO_ID ITUNES_BUNDLE_ID ".playerInfo"
#define SOURCE_SAVED_ID ITUNES_BUNDLE_ID ".sourceSaved"

#define NotifierChangedTracks           @"Changed Tracks"
#define NotifierPaused                  @"Paused"
#define NotifierStopped                 @"Stopped"
#define NotifierStarted                 @"started"

#define NotifierChangedTracksReadable   NSLocalizedString(@"Changed Tracks", nil)
#define NotifierPausedReadable          NSLocalizedString(@"Paused", nil)
#define NotifierStoppedReadable         NSLocalizedString(@"Stopped", nil)
#define NotifierStartedReadable         NSLocalizedString(@"Started", nil)