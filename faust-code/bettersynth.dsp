declare name "faustsynth";
declare author "Stefano Zambon";
declare version "0.1.0";
declare license "GPL3";
declare copyright "Copyright (C) 2020 Elk";

declare options "[nvoices:8]";

import("stdfaust.lib");
  
bettersynth = ( osc_section : ve.moog_vcf(resonance, filt_freq)) * volume
with {
    // MIDI input
    midi_freq = nentry("freq[unit:Hz][hidden]", 440, 20, 20000, 1);
    midi_gate = button("gate[hidden]");
	midi_gain = nentry("gain[hidden]", 0.25, 0, 0.25, 0.01);
  	
 	// LFO
  	lfo_freq = hslider("LFO freq[unit:Hz]", 5, 0, 10, 0.001) : si.smoo;
  	lfo_width = hslider("LFO width", 2, 0, 100, 0.001) : si.smoo;
	lfo = os.lf_triangle(lfo_freq) * lfo_width;
  
    // Envelope
    att = hslider("Attack[unit: s][scale:log]", 0.25, 0.001, 2, 0.01);
    dec = hslider("Decay[unit: s][scale:log]", 0.2, 0.001, 2, 0.01);
    sus = hslider("Sustain", 0.9, 0, 1, 0.01);
    rel = hslider("Release[unit: s][scale:log]", 1.0, 0.001, 4, 0.01);
  	env = en.adsre(att, dec, sus, rel, midi_gate);
  	
  	// Oscillators
  	osc_detune = hslider("OSC detune[unit:cents]", 1, 0, 100, 0.01) : si.smoo;
  	osc_mix = hslider("OSC mix", 0.5, 0, 1, 0.001) : si.smoo;
  	osc_freq_0 = midi_freq + lfo;
  	osc_freq_1 = osc_freq_0 * (2, (osc_detune/1200) : pow);
	osc_section = os.sawtooth(osc_freq_0) * (1 - osc_mix) + os.sawtooth(osc_freq_1) * osc_mix;

    // Filter
    cutoff = hslider("Cutoff[unit: Hz][scale:log]", 1000, 20, 6000, 0.001) : si.smoo;
	resonance = hslider("Resonance", 0.5, 0, 1, 0.001) : si.smoo;

	keyb_track = hslider("Keyboard tracking", 1, 0, 2, 0.001);
  	filt_env_amt = hslider("Filter Env Amount", 0.5, 0, 1, 0.001);
	filt_freq = (osc_freq_0 * keyb_track + cutoff + filt_env_amt * env ) : min(ma.SR / 8.0);

	// Amp
	volume = midi_gain * env;

};

effect = dm.phaser2_demo : de.delay;
process = bettersynth <: _,_;

