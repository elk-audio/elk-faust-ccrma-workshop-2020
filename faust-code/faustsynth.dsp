declare name "faustsynth";
declare author "Stefano Zambon";
declare version "0.1.0";
declare license "GPL3";
declare copyright "Copyright (C) 2020 Elk";

declare options "[nvoices:8]";

import("stdfaust.lib");

faustsynth = ( os.sawtooth(midi_freq) : fi.resonlp(filt_freq, filt_Q, midi_gain) ) * en.adsre(att, dec, sus, rel, midi_gate)
with {
    // MIDI input
    midi_freq = nentry("freq[unit:Hz][hidden]", 440, 20, 20000, 1);
    midi_gate = button("gate[hidden]");
	midi_gain = nentry("gain[hidden]", 0.25, 0, 0.25, 0.01);

    // Filter
    filt_freq = hslider("Cutoff[unit: Hz][scale:log][hidden]", 2000, 40, 6000, 0.001) : si.smoo;
    filt_Q = hslider("Q[hidden]", 1.0, 0.1, 3.0, 0.001) : si.smoo;

    // ADSR
    att = hslider("Attack[unit: s][scale:log]", 0.25, 0.001, 2, 0.01);
    dec = hslider("Decay[unit: s][scale:log]", 0.5, 0.001, 2, 0.01);
    sus = hslider("Sustain", 0.9, 0, 1, 0.01);
    rel = hslider("Release[unit: s][scale:log]", 2.0, 0.001, 4, 0.01);
};

process = faustsynth <: _,_;
