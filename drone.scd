// Low drone — run: echo " " | sclang drone.scd

s.options.numInputBusChannels = 0;
s.options.memSize = 65536;

s.waitForBoot({
    s.initTree;

    SynthDef(\drone, { |out = 0, freq = 55, amp = 0.3|
        var sig = Mix([
            SinOsc.ar(freq, 0, 0.6),
            SinOsc.ar(freq * 1.005, 0, 0.5),       // slight detune for width
            SinOsc.ar(freq * 2.01, 0, 0.3),         // soft 2nd harmonic
            SinOsc.ar(freq * 3.007, 0, 0.15),        // subtle 3rd harmonic
            LFNoise1.ar(freq * 0.5, 0.05)           // breathy noise layer
        ]);
        sig = LPF.ar(sig, freq * 4);
        sig = FreeVerb.ar(sig * amp, mix: 0.7, room: 0.95, damp: 0.3);
        Out.ar(out, sig ! 2);
    }).add;

    s.sync;

    // Pmono keeps one synth alive, slowly drifting parameters
    Pmono(\drone,
        \freq,  Pbrown(40, 70, 2, inf),              // wander between ~E1 and ~C#2
        \amp,   Pbrown(0.15, 0.35, 0.02, inf),
        \delta, Pwhite(2.0, 5.0, inf)                // update every 2-5 seconds
    ).play;
});
