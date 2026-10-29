pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id:root
    property var sink: Pipewire.defaultAudioSink
    property var mic: Pipewire.defaultAudioSource
    readonly property bool sinkReady: sink && sink.ready
    readonly property bool muted: sinkReady && sink.audio.muted
    readonly property int vol: sinkReady ? Math.round(sink.audio.volume * 100) : 0
    readonly property bool micReady: mic && mic.ready
    readonly property bool micMuted: micReady && mic.audio.muted

    //volume limits. 1-150 with 100 being unity gain.
    readonly property int minVolume: 1
    readonly property int maxVolume: 150
    readonly property int unityVolume: 100

    //every hardware output pipewire knows about (speakers, headphones, hdmi...)
    readonly property var sinks: (Pipewire.nodes ? Pipewire.nodes.values : []).filter(node => node.isSink && !node.isStream)
    //human readable name of the output we are playing through
    readonly property string sinkName: root.nodeLabel(root.sink)
    //human readable name of the microphone
    readonly property string micName: root.nodeLabel(root.mic)

    //pipewire only hands out volume/mute data for nodes that are bound,
    //so keep a tracker alive for everything we touch.
    PwObjectTracker {
      id: tracker

      objects: {
        let tracked = [];
        if (root.sink)
          tracked.push(root.sink);
        if (root.mic)
          tracked.push(root.mic);
        for (let i = 0; i < root.sinks.length; i++)
          tracked.push(root.sinks[i]);
        return tracked;
      }
    }

    //nicest name we can get for a node
    function nodeLabel(node) {
      if (!node)
        return "";
      if (node.nickname)
        return node.nickname;
      if (node.description)
        return node.description;
      return node.name;
    }

    //is this node the output we are currently playing through?
    function isCurrentSink(node) {
      if (!node || !root.sink)
        return false;
      return node.id === root.sink.id;
    }

    //set the output volume, percent is 0 - 150
    function setVolume(percent) {
      if (!root.sinkReady)
        return;
      let value = Math.max(0, Math.min(root.maxVolume, Math.round(percent)));
      root.sink.audio.volume = value / 100;
    }

    //bump the output volume by delta percent
    function nudgeVolume(delta) {
      if (!root.sinkReady)
        return;
      root.setVolume(root.vol + delta);
    }

    //mute/unmute the output
    function toggleMute() {
      if (!root.sinkReady)
        return;
      root.sink.audio.muted = !root.sink.audio.muted;
    }

    //mute/unmute the microphone
    function toggleMicMute() {
      if (!root.micReady)
        return;
      root.mic.audio.muted = !root.mic.audio.muted;
    }

    //move playback over to another output
    function setDefaultSink(node) {
      if (!node)
        return;
      Pipewire.preferredDefaultAudioSink = node;
    }
}
