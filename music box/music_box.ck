/*
Music_Box.ck
1
A program made to automatically play when a raspberry pi is initalized.
It is a sort of 'Jazz Band' composition
*/
Clarinet clarinet => JCRev lead2r => Pan2 lead2p => dac;
//instrument playing melody
Brass lead1 => JCRev lead1R => Pan2 lead1p => dac;
//three osc's playing harmony
SinOsc osc1 => JCRev osc1R => Pan2 osc1p => dac;
SqrOsc osc2 => JCRev osc2R => Pan2 osc2p => dac; 
TriOsc osc3 => Pan2 osc3p => dac;
0 => osc1.gain => osc2.gain => osc3.gain;//this chucks 0 to the gain of all three osc's

//i created five soundbufs for my different types of samples
SndBuf kick  => Pan2 kickP => dac;//JCRev drumRev => dac;
SndBuf snare => Pan2 snareP => JCRev drumRev => dac;// => dac;
SndBuf hiHat => ADSR adsr => Pan2 hiHatP => dac;//rumRev;// => dac;
SndBuf click => Pan2 clickP => drumRev;// => dac;
SndBuf other => Pan2 otherP => dac;//drumRev;// => dac;

drumRev.mix(0.1);
//sets tha gain of the reverb
.85 => lead1R.gain;
//makes the master signal 40% reverb and 60% clean 
0.4 => lead1R.mix;
//here i create the end point for the composition ensuring it is only 30 seconds
now + 30::second => time end;
//the notes in D dorain, this time i decided to just do one octave worth and to use functions to change the pitch
[50,52,53,55,57,59,60] @=> int tone[]; 
//this is an Array that holds a melody i call opon in the third section
[38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0,38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0] @=> int melody[];

dur whole, half, quarter, eighth, sixteenth, thirtysecond;

//sets up nots values for the work, the pulse is in quarter notes
fun void setNoteLength(float length){
    (length/32)::second =>  thirtysecond;
    (length/16)::second => sixteenth;
    (length/8)::second => eighth;
    (length/4)::second => quarter;
    (length/2)::second => half;
    length::second => whole;
}

string kick_samples[5];
me.dir() + "/audio/kick_01.wav" => kick_samples[0];
me.dir() + "/audio/kick_02.wav" => kick_samples[1];
me.dir() + "/audio/kick_03.wav" => kick_samples[2];
me.dir() + "/audio/kick_04.wav" => kick_samples[3];
me.dir() + "/audio/kick_05.wav" => kick_samples[4];
string snare_samples[3];
me.dir() + "/audio/snare_01.wav" => snare_samples[0];
me.dir() + "/audio/snare_02.wav" => snare_samples[1];
me.dir() + "/audio/snare_03.wav" => snare_samples[2];
string hiHat_samples[4];
me.dir() + "/audio/hihat_01.wav" => hiHat_samples[0];
me.dir() + "/audio/hihat_02.wav" => hiHat_samples[1];
me.dir() + "/audio/hihat_03.wav" => hiHat_samples[2];
me.dir() + "/audio/hihat_04.wav" => hiHat_samples[3];
string click_samples[5];
me.dir() + "/audio/click_01.wav" => click_samples[0];
me.dir() + "/audio/click_02.wav" => click_samples[1];
me.dir() + "/audio/click_03.wav" => click_samples[2];
me.dir() + "/audio/click_04.wav" => click_samples[3];
me.dir() + "/audio/click_05.wav" => click_samples[4];
string other_samples[7];
me.dir() + "/audio/clap_01.wav" => other_samples[0];
me.dir() + "/audio/cowbell_01.wav" => other_samples[1];
me.dir() + "/audio/stereo_fx_01.wav" => other_samples[2];
me.dir() + "/audio/stereo_fx_02.wav" => other_samples[3];
me.dir() + "/audio/stereo_fx_03.wav" => other_samples[4];
me.dir() + "/audio/stereo_fx_04.wav" => other_samples[5];
me.dir() + "/audio/stereo_fx_05.wav" => other_samples[6];

fun void assignKick(int sampNum){
    if (sampNum < kick_samples.cap()){
        kick_samples[sampNum] => kick.read;
        kick.samples() => kick.pos;
    }  
    else{
        <<<"Sorry but there are not that many kick samples">>>;   
        <<<kick_samples.cap()>>>;
    }
}

fun void assignSnare(int sampNum){
    if (sampNum < snare_samples.cap()){
        snare_samples[sampNum] => snare.read;
        snare.samples() => snare.pos;
    }  
    else{
        <<<"Sorry but there are not that many snare samples">>>;   
        <<<snare_samples.cap()>>>;
    }
}
fun void assignClick(int sampNum){
    if (sampNum < click_samples.cap()){
        click_samples[sampNum] => click.read;
        click.samples() => click.pos;
    }  
    else{
        <<<"Sorry but there are not that many click samples">>>;   
        <<<click_samples.cap()>>>;
    }
}
fun void assignSfx(int sampNum){
    if (sampNum < other_samples.cap()){
        other_samples[sampNum] => other.read;
        other.samples() => other.pos;
    }  
    else{
        <<<"Sorry but there are not that many SFX(other) samples">>>;   
        <<<other_samples.cap()>>>;
    }
}
fun void assignHH(int sampNum){
    if (sampNum < hiHat_samples.cap()){
        hiHat_samples[sampNum] => hiHat.read;
        hiHat.samples() => hiHat.pos;
    }  
    else{
        <<<"Sorry but there are not that many high hat samples">>>;   
        <<<hiHat_samples.cap()>>>;
    }
}
//this part of the code sets everything to the off position
//sets all the sound buffs to the end of their samples so they dont play at the begenning of the recording.
//makes a while loop that lasts 4 measures
fun void intro (int max, int bpm){
    /*
    max is the number of iterations the loop cycles through
    bmp is the number of beats per measure
    */
    for(0 => int counter; counter < max; counter++){
        counter % bpm => int beat;//modulo to sequence all the Sound buffs
        //randomezed the brass settings each beat
        Math.random2f(.5, .8) => lead1.slide;
        Math.random2f(3, 12) => lead1.vibratoFreq;
        Math.random2f(.6, .8) => lead1.vibratoGain;
        Math.random2f(.5, .8) => lead1.lip;
        
        //this is the kick, will play on the 1st, 9th and 15th beats of each measure
        if ( (beat == 0 ) || (beat == 8) || (beat == 14))
        {
            Math.random2f(0.77, 0.82) => kick.gain;
            0 => kick.pos;
            0.9 => kick.rate;
        }
        //plays the snare on the 4th, 8th and 12th beats
        if ((beat == 3) || (beat == 7) || (beat == 11))
        {
            0 => snare.pos;
            1.2 => snare.rate;
        }   
        //The Instruments, the brass insstrument will play on the 2end and 10 beats
        if ((beat == 1))
        {
            1 => lead1.volume;
            Std.mtof(tone[0]) => lead1.freq;
            panM(.8) => lead1p.pan;
        }   
        if ((beat == 9))
        {
            1 => lead1.volume;
            Std.mtof(tone[4]) => lead1.freq;
            panM(.8) => lead1p.pan;
            
        }    
        //sets the timing of the loop to an eighth note
        eighth => now;//turns all osc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
        //turns the brass off
        lead1.noteOff;
    }
}
//create a floating point value that i can use to fade the brass in and out
fun void verse(int max, int bpm){
    for(0 => int counter; counter < max; counter++){
        //creates a modulo that i will use as a sequencer
        counter % bpm => int beat;
        //plays the kick on certain beats
        if ( (beat == 0 ) || (beat == 8) || (beat == 14))
        {
            0 => kick.pos;
            Math.random2f(0.85,0.95) => kick.rate;
        }
        //plays the snare on certain beats
        if ((beat == 3) || (beat == 7) || (beat == 11))
        {
            Math.random2f(.1,.15) => snareP.pan;
            0 => snare.pos;
            Math.random2f(1.1,1.3) => snare.rate;
        }
        //plays the HH each beat
        Math.random2f(0.15,0.18) => hiHat.gain;
        0 => hiHat.pos;
        Math.random2f(.95,1.05) => hiHat.rate;
        //plays melody in brass with harmony in OSc's
        if ((beat ==7))
        {
            Std.mtof(tone[Math.random2(0, tone.cap()-1)]) => float tone1;
            0.04 => osc1.gain => osc2.gain;
            tone1 => osc1.freq;  
            tone1*1.5 => osc2.freq;  
        }
        
        if ((beat == 1))
        {
            0.03 => osc2.gain;
            Std.mtof(tone[0]) => float pitch;
            pitch => osc2.freq;  
        }
        
        if ((beat == 9))
        {
            0.06 => osc3.gain;
            Std.mtof(tone[0]) => float pitch;
            Std.mtof(melody[Math.random2(0,melody.cap())]) => clarinet.freq;
            maybe * 1 => clarinet.noteOn;
            //1 => clarinet.keyOn;
            ( pitch / 2 ) => osc2.freq;   
        }
        //moves counter up
        //moves time
        eighth => now;
        //turns OSc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
        //sets value for fade out and fades out, then back in
        lead1.noteOff;
        clarinet.noteOff;
    }
}
//creates another counter
fun void bridge(int max, int bpm){
    for(0 => int counter; counter < max; counter++){
        
        //creates another sequencer
        counter % bpm => int beat;
        //randomizes the values of the lead instrument
        Math.random2f(0.5,0.95) => lead1.gain;
        Math.random2f(.8, .9) => lead1.slide;
        Math.random2f(10, 12) => lead1.vibratoFreq;
        Math.random2f(.8, 1) => lead1.vibratoGain;
        Math.random2f(.9, 1) => lead1.lip;
        panM(1) => lead1p.pan;
        
        //plays the kick
        if ( (beat == 0 ) || (beat == 8) || (beat == 14))
        {
            0 => kick.pos;
            Math.random2f(0.85,0.95) => kick.rate;
        }
        //plays the snare
        if ((beat == 3) || (beat == 7) || (beat == 11))
        {
            Math.random2f(.1,.15) => snareP.pan;
            0 => snare.pos;
            Math.random2f(1.1,1.3) => snare.rate;
        }
        
        //adds a clicker, plays the clicker
        if (( beat == 0) || (beat == 2) || (beat == 4) || (beat == 6) || (beat == 8) || (beat == 10) || (beat == 14) || (beat == 15) )
        {
            Math.random2f(0.25,0.3) => click.gain;
            Math.random2f(-.1,.1) => clickP.pan;
            0 => click.pos;
            0.5 => click.rate;
            
        }
        //plays the melody 
        if ( (beat == 5))
        {
            lead1.noteOn;
            Math.random2f(0.5,0.95) => lead1.gain;
            1 => lead1.volume;
            Std.mtof(tone[0])*1.5 => lead1.freq;       
        }
        //plays melody
        if ((beat == 9) || (beat == 14))
        {
            lead1.noteOn;
            Math.random2f(0.5,0.95) => lead1.gain;
            1 => lead1.volume;
            Std.mtof(tone[4])*1.5 => lead1.freq;        
        }
        //hiHat plays on every beat except for the 7th, 15th and 16th
        if ((beat == 6) || (beat == 14) || (beat == 15))
        {
            hiHat.samples() => hiHat.pos;
        }
        else
        {
            Math.random2f(-.4,.4) => hiHatP.pan;
            Math.random2f(0.15,0.18) => hiHat.gain;
            0 => hiHat.pos;
            Math.random2f(.95,1.05) => hiHat.rate;
        }       
        eighth => now;
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
}

fun void outro(int max, int bpm){
    for(0 => int counter; counter < max; counter++)
    {
        //randomizes the settings for the lead again
        Math.random2f(0.5,0.95) => lead1.gain;
        panM(1.3) => lead1p.pan;
        Math.random2f(.8, .9) => lead1.slide;
        Math.random2f(10, 12) => lead1.vibratoFreq;
        Math.random2f(.8, 1) => lead1.vibratoGain;
        Math.random2f(.9, 1) => lead1.lip;
        //sequencer
        counter % bpm => int beat;
        //plays the kick
        if ( (beat == 0 ) || (beat == 8) || (beat == 14))
        {
            0 => kick.pos;
            Math.random2f(0.85,0.95) => kick.rate;
        }
        //plays the snare
        if ((beat == 3) || (beat == 7) || (beat == 11))
        {
            Math.random2f(.1,.15) => snareP.pan;
            0 => snare.pos;
            Math.random2f(1.1,1.3) => snare.rate;
        }
        //plays the click
        if (( beat == 0) || (beat == 2) || (beat == 4) || (beat == 6) || (beat == 8) || (beat == 10) || (beat == 14) || (beat == 15) )
        {
            Math.random2f(-.3,0) => clickP.pan;
            0 => click.pos;
            0.5 => click.rate;           
        }
        //plays the cowbells
        if ((beat == 3))
        {
            0.75 => other.gain;
            other.samples() => other.pos;
            -.5 => other.rate;
            Math.random2f(-.3,.3) => otherP.pan;
        }
        //hiHat plays on every beat
        Math.random2f(-.4,.4) => hiHatP.pan;
        Math.random2f(0.15,0.18) => hiHat.gain;
        0 => hiHat.pos;
        Math.random2f(.95,1.05) => hiHat.rate;
        if ((beat ==7))
        {
            Std.mtof(tone[Math.random2(0, tone.cap()-1)]) => float tone1;
            0.06 => osc1.gain => osc2.gain => osc3.gain;
            tone1 => osc1.freq;  
            tone1*1.5 => osc2.freq; 
            tone1*2 => osc3.freq; 
        }
        if ((beat == 1))
        {
            0.95 => lead1.volume;
            Std.mtof(tone[0]) => lead1.freq;         
        }
        if ((beat == 9))
        {
            0.95 => lead1.volume;
            Std.mtof(tone[4]) => lead1.freq;           
        }
        eighth => now;
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
}

//Utility Functions - - - - readability?
fun float panEx(float f)
{
    return Math.random2f(-.8,.8)*f;   
}
fun float panM (float f)
{
    return Math.random2f(-.4,.4)*f;   
}
fun float octave (float originalFreq)
{
    return (originalFreq*2);   
}
fun float fifth (float originalFreq)
{
    return (originalFreq*1.5);
}
/////////////////////////////////////////////////////
/*
The Composition Itself
*/
/////////////////////////////////////////////////////
//        Assigning Some Initial Samples
/////////////////////////////////////////////////////
assignKick(0);
assignSnare(0);
assignClick(0);
assignSfx(2);
assignHH(2);

setNoteLength(1.0);
/////////////////////////////////////////////////////
while(1){
    intro(32, 16);
    intro(32, Math.random2(0,5);
    assignSnare(1);
    verse(128, 12);
    assignSnare(0);
    bridge(128,16);
    outro(128,12);
    outro(32,Math.random2(0,9));
    quarter => now;
    //reset the Sample Mix
    <<<"Restarting Program">>>;
    if(maybe){assignKick(Math.random2(0,4));};
    if(maybe){assignSnare(Math.random2(0,2));};
    if(maybe){assignClick(Math.random2(0,4));};
    if(maybe){assignSfx(Math.random2(0,2));};
    if(maybe){assignHH(Math.random2(0,3));};
    <<<"New Samples Selected">>>;
}

