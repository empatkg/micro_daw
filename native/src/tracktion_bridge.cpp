#include "tracktion_bridge.h"
#include <tracktion_engine/tracktion_engine.h>
#include <memory>

namespace te = tracktion::engine;

struct EngineWrapper {
    std::unique_ptr<juce::ScopedJuceInitialiser_GUI> juceInit;
    std::unique_ptr<te::Engine> engine;
};

extern "C" {

TE_EXPORT TE_Engine te_engine_create(const char* appName, const char* logsPath) {
    auto* ew = new EngineWrapper();
    ew->juceInit = std::make_unique<juce::ScopedJuceInitialiser_GUI>();
    ew->engine = std::make_unique<te::Engine>(appName != nullptr ? appName : "MicroDAW");
    return ew;
}

TE_EXPORT void te_engine_destroy(TE_Engine engine) {
    if (engine) {
        delete static_cast<EngineWrapper*>(engine);
    }
}

TE_EXPORT TE_Edit te_edit_create_empty(TE_Engine engine, const char* editFilePath) {
    auto* ew = static_cast<EngineWrapper*>(engine);
    if (!ew || !ew->engine) return nullptr;

    juce::File file(editFilePath != nullptr ? editFilePath : "");
    auto edit = te::createEmptyEdit(*ew->engine, file);
    return edit.release();
}

TE_EXPORT void te_edit_destroy(TE_Edit edit) {
    if (edit) {
        delete static_cast<te::Edit*>(edit);
    }
}

TE_EXPORT void te_edit_save(TE_Edit edit) {
    auto* e = static_cast<te::Edit*>(edit);
    if (e) {
        te::EditFileOperations(*e).save(true, true);
    }
}

TE_EXPORT void te_transport_play(TE_Edit edit, int record) {
    auto* e = static_cast<te::Edit*>(edit);
    if (e) e->getTransport().play(record != 0);
}

TE_EXPORT void te_transport_stop(TE_Edit edit) {
    auto* e = static_cast<te::Edit*>(edit);
    if (e) e->getTransport().stop(false, false);
}

TE_EXPORT void te_transport_set_bpm(TE_Edit edit, double bpm) {
    auto* e = static_cast<te::Edit*>(edit);
    if (e && e->tempoSequence.getNumTempos() > 0) {
        e->tempoSequence.getTempo(0)->setBpm(bpm);
    }
}

TE_EXPORT double te_transport_get_position_beats(TE_Edit edit) {
    auto* e = static_cast<te::Edit*>(edit);
    if (!e) return 0.0;
    auto posSeconds = e->getTransport().getPosition();
    return e->tempoSequence.toBeats(posSeconds).inBeats();
}

TE_EXPORT void te_transport_set_loop_range(TE_Edit edit, double startBeat, double endBeat) {
    auto* e = static_cast<te::Edit*>(edit);
    if (!e) return;
    auto start = e->tempoSequence.toTime(tracktion::BeatPosition::fromBeats(startBeat));
    auto end = e->tempoSequence.toTime(tracktion::BeatPosition::fromBeats(endBeat));
    e->getTransport().setLoopRange(tracktion::TimeRange(start, end));
}

TE_EXPORT void te_transport_enable_loop(TE_Edit edit, int enabled) {
    auto* e = static_cast<te::Edit*>(edit);
    if (e) e->getTransport().looping = (enabled != 0);
}

TE_EXPORT TE_Track te_track_insert_instrument_track(TE_Edit edit, const char* name) {
    auto* e = static_cast<te::Edit*>(edit);
    if (!e) return nullptr;
    auto track = e->insertNewAudioTrack(te::TrackInsertPoint(nullptr, nullptr), nullptr);
    if (track && name) {
        track->setName(juce::String(name));
    }
    return track.get();
}

TE_EXPORT void te_track_set_color(TE_Track track, int argb) {
    auto* t = static_cast<te::Track*>(track);
    if (t) t->setColour(juce::Colour((juce::uint32)argb));
}

TE_EXPORT void te_track_set_volume(TE_Track track, float db) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (t && t->getVolumePlugin()) {
        t->getVolumePlugin()->setVolumeDb(db);
    }
}

TE_EXPORT void te_track_set_pan(TE_Track track, float pan) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (t && t->getVolumePlugin()) {
        t->getVolumePlugin()->setPan(pan);
    }
}

TE_EXPORT void te_track_mute(TE_Track track, int mute) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (t) t->setMute(mute != 0);
}

TE_EXPORT void te_track_solo(TE_Track track, int solo) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (t) t->setSolo(solo != 0);
}

TE_EXPORT TE_Clip te_step_clip_create(TE_Track track, const char* name, double startBeat, double lengthBeats) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (!t) return nullptr;
    auto& ts = t->edit.tempoSequence;

    auto start = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat));
    auto end = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat + lengthBeats));

    te::ClipPosition clipPos { tracktion::TimeRange (start, end), {} };

    auto clip = t->insertNewClip(te::TrackItem::Type::step,
                                 juce::String(name != nullptr ? name : "Step"),
                                 clipPos,
                                 nullptr);
    return clip.get();
}

TE_EXPORT void te_step_clip_set_num_channels(TE_Clip clip, int numChannels) {
    // Diproses otomatis oleh pola internal StepClip
}

TE_EXPORT void te_step_clip_set_num_steps(TE_Clip clip, int numSteps) {
    // Diproses otomatis oleh pola internal StepClip
}

TE_EXPORT void te_step_clip_set_cell(TE_Clip clip, int channel, int step, float velocity) {
    auto* sc = dynamic_cast<te::StepClip*>(static_cast<te::Clip*>(clip));
    if (!sc) return;
    sc->setPatternChannelSequenceStep(0, channel, step, velocity > 0.01f);
}

TE_EXPORT void te_step_clip_clear_channel(TE_Clip clip, int channel) {
    auto* sc = dynamic_cast<te::StepClip*>(static_cast<te::Clip*>(clip));
    if (!sc) return;
    sc->emptyPatternChannelSequence(0, channel);
}

TE_EXPORT void te_step_clip_set_channel_note(TE_Clip clip, int channel, int midiNote) {
    auto* sc = dynamic_cast<te::StepClip*>(static_cast<te::Clip*>(clip));
    if (!sc) return;
    sc->setPatternChannelNote(0, channel, midiNote);
}

TE_EXPORT TE_Clip te_midi_clip_create(TE_Track track, const char* name, double startBeat, double lengthBeats) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (!t) return nullptr;
    auto& ts = t->edit.tempoSequence;

    auto start = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat));
    auto end = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat + lengthBeats));

    te::ClipPosition clipPos { tracktion::TimeRange (start, end), {} };

    auto clip = t->insertNewClip(te::TrackItem::Type::midi,
                                 juce::String(name != nullptr ? name : "Midi"),
                                 clipPos,
                                 nullptr);
    return clip.get();
}

TE_EXPORT void te_midi_clip_add_note(TE_Clip clip, int pitch, double startBeat, double lengthBeats, float velocity, int slide) {
    auto* mc = dynamic_cast<te::MidiClip*>(static_cast<te::Clip*>(clip));
    if (!mc) return;

    auto& seq = mc->getSequence();
    auto& ts = mc->edit.tempoSequence;

    auto start = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat));
    auto len = ts.toTime(tracktion::BeatPosition::fromBeats(lengthBeats)) - start;

    seq.addNote(pitch, start, len, juce::jlimit(0, 127, (int)(velocity * 127.0f)), 0, nullptr);
}

TE_EXPORT void te_midi_clip_clear(TE_Clip clip) {
    auto* mc = dynamic_cast<te::MidiClip*>(static_cast<te::Clip*>(clip));
    if (mc) {
        mc->getSequence().clear();
    }
}

TE_EXPORT TE_Clip te_audio_clip_create(TE_Track track, const char* name, const char* audioFilePath, double startBeat, double lengthBeats) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (!t || !audioFilePath) return nullptr;
    auto& ts = t->edit.tempoSequence;

    auto start = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat));
    auto end = ts.toTime(tracktion::BeatPosition::fromBeats(startBeat + lengthBeats));

    te::ClipPosition clipPos { tracktion::TimeRange (start, end), {} };
    juce::File file(audioFilePath);

    auto clip = t->insertWaveClip(juce::String(name != nullptr ? name : "Audio"),
                                  file,
                                  clipPos,
                                  false);
    return clip.get();
}

TE_EXPORT void te_audio_clip_set_time_stretch(TE_Clip clip, double ratio) {
    auto* ac = dynamic_cast<te::WaveAudioClip*>(static_cast<te::Clip*>(clip));
    if (ac) {
        ac->setSpeedRatio(ratio);
    }
}

TE_EXPORT void te_audio_clip_set_pitch_shift(TE_Clip clip, double semitones) {
    auto* ac = dynamic_cast<te::WaveAudioClip*>(static_cast<te::Clip*>(clip));
    if (ac) {
        ac->setPitchSemitones((float)semitones);
    }
}

TE_EXPORT TE_Plugin te_track_load_plugin(TE_Track track, const char* pluginId) {
    auto* t = static_cast<te::AudioTrack*>(track);
    if (!t || !pluginId) return nullptr;

    auto plugin = t->edit.getPluginCache().createNewPlugin(juce::String(pluginId));
    if (plugin) {
        t->pluginList.insertPlugin(plugin, 0, nullptr);
        return plugin.get();
    }
    return nullptr;
}

TE_EXPORT TE_Plugin te_track_add_effect(TE_Track track, const char* effectId, int slot) {
    return te_track_load_plugin(track, effectId);
}

} // extern "C"