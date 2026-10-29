#ifndef TRACKTION_BRIDGE_H
#define TRACKTION_BRIDGE_H

#if defined(_WIN32) || defined(__CYGWIN__)
  #ifdef BUILDING_TRACKTION_BRIDGE
    #define TE_EXPORT __declspec(dllexport)
  #else
    #define TE_EXPORT __declspec(dllimport)
  #endif
#else
  #if __GNUC__ >= 4
    #define TE_EXPORT __attribute__ ((visibility ("default")))
  #else
    #define TE_EXPORT
  #endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef void* TE_Engine;
typedef void* TE_Edit;
typedef void* TE_Track;
typedef void* TE_Clip;
typedef void* TE_Plugin;

TE_EXPORT TE_Engine te_engine_create(const char* appName, const char* logsPath);
TE_EXPORT void te_engine_destroy(TE_Engine engine);

TE_EXPORT TE_Edit te_edit_create_empty(TE_Engine engine, const char* editFilePath);
TE_EXPORT void te_edit_destroy(TE_Edit edit);
TE_EXPORT void te_edit_save(TE_Edit edit);

TE_EXPORT void te_transport_play(TE_Edit edit, int record);
TE_EXPORT void te_transport_stop(TE_Edit edit);
TE_EXPORT void te_transport_set_bpm(TE_Edit edit, double bpm);
TE_EXPORT double te_transport_get_position_beats(TE_Edit edit);
TE_EXPORT void te_transport_set_loop_range(TE_Edit edit, double startBeat, double endBeat);
TE_EXPORT void te_transport_enable_loop(TE_Edit edit, int enabled);

TE_EXPORT TE_Track te_track_insert_instrument_track(TE_Edit edit, const char* name);
TE_EXPORT void te_track_set_color(TE_Track track, int argb);
TE_EXPORT void te_track_set_volume(TE_Track track, float db);
TE_EXPORT void te_track_set_pan(TE_Track track, float pan);
TE_EXPORT void te_track_mute(TE_Track track, int mute);
TE_EXPORT void te_track_solo(TE_Track track, int solo);

TE_EXPORT TE_Clip te_step_clip_create(TE_Track track, const char* name, double startBeat, double lengthBeats);
TE_EXPORT void te_step_clip_set_num_channels(TE_Clip clip, int numChannels);
TE_EXPORT void te_step_clip_set_num_steps(TE_Clip clip, int numSteps);
TE_EXPORT void te_step_clip_set_cell(TE_Clip clip, int channel, int step, float velocity);
TE_EXPORT void te_step_clip_clear_channel(TE_Clip clip, int channel);
TE_EXPORT void te_step_clip_set_channel_note(TE_Clip clip, int channel, int midiNote);

TE_EXPORT TE_Clip te_midi_clip_create(TE_Track track, const char* name, double startBeat, double lengthBeats);
TE_EXPORT void te_midi_clip_add_note(TE_Clip clip, int pitch, double startBeat, double lengthBeats, float velocity, int slide);
TE_EXPORT void te_midi_clip_clear(TE_Clip clip);

TE_EXPORT TE_Clip te_audio_clip_create(TE_Track track, const char* name, const char* audioFilePath, double startBeat, double lengthBeats);
TE_EXPORT void te_audio_clip_set_time_stretch(TE_Clip clip, double ratio);
TE_EXPORT void te_audio_clip_set_pitch_shift(TE_Clip clip, double semitones);

TE_EXPORT TE_Plugin te_track_load_plugin(TE_Track track, const char* pluginId);
TE_EXPORT TE_Plugin te_track_add_effect(TE_Track track, const char* effectId, int slot);

#ifdef __cplusplus
}
#endif

#endif
