import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

final DynamicLibrary _lib = Platform.isAndroid
    ? DynamicLibrary.open('libtracktion_bridge.so')
    : Platform.isLinux
        ? DynamicLibrary.open('libtracktion_bridge.so')
        : Platform.isIOS
            ? DynamicLibrary.process()
            : DynamicLibrary.open('tracktion_bridge.dll');

typedef TE_Engine = Pointer<Void>;
typedef TE_Edit = Pointer<Void>;
typedef TE_Track = Pointer<Void>;
typedef TE_Clip = Pointer<Void>;
typedef TE_Plugin = Pointer<Void>;

final TE_Engine Function(Pointer<Utf8>, Pointer<Utf8>) teEngineCreate = _lib
    .lookup<NativeFunction<TE_Engine Function(Pointer<Utf8>, Pointer<Utf8>)>>('te_engine_create')
    .asFunction();

final void Function(TE_Engine) teEngineDestroy = _lib
    .lookup<NativeFunction<Void Function(TE_Engine)>>('te_engine_destroy')
    .asFunction();

final TE_Edit Function(TE_Engine, Pointer<Utf8>) teEditCreateEmpty = _lib
    .lookup<NativeFunction<TE_Edit Function(TE_Engine, Pointer<Utf8>)>>('te_edit_create_empty')
    .asFunction();

final void Function(TE_Edit) teEditSave = _lib
    .lookup<NativeFunction<Void Function(TE_Edit)>>('te_edit_save')
    .asFunction();

final void Function(TE_Edit, Int32) teTransportPlay = _lib
    .lookup<NativeFunction<Void Function(TE_Edit, Int32)>>('te_transport_play')
    .asFunction();

final void Function(TE_Edit) teTransportStop = _lib
    .lookup<NativeFunction<Void Function(TE_Edit)>>('te_transport_stop')
    .asFunction();

final void Function(TE_Edit, Double) teTransportSetBpm = _lib
    .lookup<NativeFunction<Void Function(TE_Edit, Double)>>('te_transport_set_bpm')
    .asFunction();

final TE_Track Function(TE_Edit, Pointer<Utf8>) teTrackInsertInstrumentTrack = _lib
    .lookup<NativeFunction<TE_Track Function(TE_Edit, Pointer<Utf8>)>>('te_track_insert_instrument_track')
    .asFunction();

final TE_Clip Function(TE_Track, Pointer<Utf8>, Double, Double) teStepClipCreate = _lib
    .lookup<NativeFunction<TE_Clip Function(TE_Track, Pointer<Utf8>, Double, Double)>>('te_step_clip_create')
    .asFunction();

final void Function(TE_Clip, Int32, Int32, Float) teStepClipSetCell = _lib
    .lookup<NativeFunction<Void Function(TE_Clip, Int32, Int32, Float)>>('te_step_clip_set_cell')
    .asFunction();

final void Function(TE_Clip, Int32, Int32) teStepClipSetChannelNote = _lib
    .lookup<NativeFunction<Void Function(TE_Clip, Int32, Int32)>>('te_step_clip_set_channel_note')
    .asFunction();

final TE_Clip Function(TE_Track, Pointer<Utf8>, Double, Double) teMidiClipCreate = _lib
    .lookup<NativeFunction<TE_Clip Function(TE_Track, Pointer<Utf8>, Double, Double)>>('te_midi_clip_create')
    .asFunction();

final void Function(TE_Clip, Int32, Double, Double, Float, Int32) teMidiClipAddNote = _lib
    .lookup<NativeFunction<Void Function(TE_Clip, Int32, Double, Double, Float, Int32)>>('te_midi_clip_add_note')
    .asFunction();
