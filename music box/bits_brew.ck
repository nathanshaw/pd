<<<"Nathan Shaw - Assignment 5">>>;
//i decided to use four different osc's, to sin , one square and one triangle

//instrument playing melody
Brass lead1 => JCRev lead1R => Pan2 lead1p => dac;
//three osc's playing harmony
SinOsc osc1 => JCRev osc1R => Pan2 osc1p => dac;
SqrOsc osc2 => JCRev  osc2R => Pan2 osc2p => dac; 
TriOsc osc3 => Pan2 osc3p => dac;
//i created five soundbufs for my different types of samples
SndBuf kick => Pan2 kickP => dac;
SndBuf snare => Pan2 snareP => dac;
SndBuf hiHat => Pan2 hiHatP => dac;
SndBuf click => Pan2 clickP => dac;
SndBuf other => Pan2 otherP => dac;



//sets tha gain of the reverb
1 => lead1R.gain;
//makes the master signal 40% reverb and 60% clean 
0.6 => lead1R.mix;

//here i create the end point for the composition ensuring it is only 30 seconds

now + 60::second => time end;

//the notes in D dorain, this time i decided to just do one octave worth and to use functions to change the pitch
[50,52,53,55,57,59,60] @=> int tone[]; 
//this is an Array that holds a melody i call opon in the third section
[38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0,38,50,52,48,52,0,0,38,50,0,0,59,61,59,50,38,60,55,51,0,0,0] @=> int melody[];
//sets up nots values for the work, the pulse is in quarter notes
.031225::second => dur thirtysecond;
.0625::second => dur sixteenth;
.125::second => dur eighth;
.25::second => dur quarter;
.5::second => dur half;
.75::second => dur dotted;
1::second => dur whole;

string kick_samples[5];//load up an array with all the kick samples
me.dir() + "/audio/kick_01.wav" => kick_samples[0];
me.dir() + "/audio/kick_02.wav" => kick_samples[1];
me.dir() + "/audio/kick_03.wav" => kick_samples[2];
me.dir() + "/audio/kick_04.wav" => kick_samples[3];
me.dir() + "/audio/kick_05.wav" => kick_samples[4];

string snare_samples[3];//loads up snare array

me.dir() + "/audio/snare_01.wav" => snare_samples[0];
me.dir() + "/audio/snare_02.wav" => snare_samples[1];
me.dir() + "/audio/snare_03.wav" => snare_samples[2];

string hiHat_samples[4];//hihat array

me.dir() + "/audio/hihat_01.wav" => hiHat_samples[0];
me.dir() + "/audio/hihat_02.wav" => hiHat_samples[1];
me.dir() + "/audio/hihat_03.wav" => hiHat_samples[2];
me.dir() + "/audio/hihat_04.wav" => hiHat_samples[3];

string click_samples[5];//click array

me.dir() + "/audio/click_01.wav" => click_samples[0];
me.dir() + "/audio/click_02.wav" => click_samples[1];
me.dir() + "/audio/click_03.wav" => click_samples[2];
me.dir() + "/audio/click_04.wav" => click_samples[3];
me.dir() + "/audio/click_05.wav" => click_samples[4];

string other_samples[7];//all other samples

me.dir() + "/audio/clap_01.wav" => other_samples[0];
me.dir() + "/audio/cowbell_01.wav" => other_samples[1];
me.dir() + "/audio/stereo_fx_01.wav" => other_samples[2];
me.dir() + "/audio/stereo_fx_02.wav" => other_samples[3];
me.dir() + "/audio/stereo_fx_03.wav" => other_samples[4];
me.dir() + "/audio/stereo_fx_04.wav" => other_samples[5];
me.dir() + "/audio/stereo_fx_05.wav" => other_samples[6];
//assigns specific samples to each Sound Buff
snare_samples[0] => snare.read;
kick_samples[1] => kick.read;  
hiHat_samples[1] => hiHat.read;
click_samples[0] => click.read;
other_samples[1] => other.read;

//this part of the code sets everything to the off position
kick.samples() => kick.pos;//sets all the sound buffs to the end of their samples so they dont play at the begenning of the recording.
snare.samples() => snare.pos;
hiHat.samples() => hiHat.pos;
click.samples() => click.pos;
other.samples() => other.pos;

0 => osc1.gain => osc2.gain => osc3.gain;//this chucks 0 to the gain of all three osc's

//creates a counter that the structure of the rest of the song follows
0 => int counter;


//makes a while loop that lasts 4 measures
while (counter < 128)
{
    counter % 16 => int beat;//modulo to sequence all the Sound buffs
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
    
    //moves the counter up
    counter++;
    //sets the timing of the loop to an eighth note
    eighth => now;//turns all osc's off
    0 => osc1.gain => osc2.gain => osc3.gain;
    //turns the brass off
    lead1.noteOff;
}
//create a floating point value that i can use to fade the brass in and out
1 => float leadV;
//create a loop for another 4 measures
while (counter < 256)
    //creates a modulo that i will use as a sequencer
    {
        counter % 16 => int beat;
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
            
            ( pitch / 2 ) => osc2.freq;   
        }
        //moves counter up
        counter++;
        //moves time
        eighth => now;
        //turns OSc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
        //sets value for fade out and fades out, then back in
        leadV - 0.015  => leadV;
        leadV => lead1.gain;
        lead1.noteOff;
    }
    //creates another counter
    0 => int mCount;
    //create the next loop, third section
    while (counter < 352)
    { 
        //creates another sequencer
        counter % 16 => int beat;
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
        
        counter++;//moves the counter up
        //moves time
        eighth => now;
        //turns the osc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
    
    
    //creates the last loop
    while (counter < 480)
    {
        //randomizes the settings for the lead again
        Math.random2f(0.5,0.95) => lead1.gain;
        panM(1.3) => lead1p.pan;
        Math.random2f(.8, .9) => lead1.slide;
        Math.random2f(10, 12) => lead1.vibratoFreq;
        Math.random2f(.8, 1) => lead1.vibratoGain;
        Math.random2f(.9, 1) => lead1.lip;
        //sequencer
        counter % 16 => int beat;
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
        
        //plays the melody while harmonizing with the three osc's
        if ((beat ==7))
        {
            Std.mtof(tone[Math.random2(0, tone.cap()-1)]) => float tone1;
            0.06 => osc1.gain => osc2.gain => osc3.gain;
            tone1 => osc1.freq;  
            tone1*1.5 => osc2.freq; 
            tone1*2 => osc3.freq; 
        }
        //plays the molody again
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
        
        counter++;//moves the counter up
        
       //moves time
        eighth => now;
        //turns the Osc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
    
    //my functions
    fun float panEx (float f)
    {
        return Math.random2f(-.8,.8)*f;
        
    }
    //my second random pan function
    
    fun float panM (float f)
    {
        return Math.random2f(-.4,.4)*f;   
    }
    
    fun float octave (float originalFreq)
    {
        return (originalFreq*2);   
    }
    //i borrowed this fifth function from the code in class
    fun float fifth (float originalFreq)
    {
        return (originalFreq*1.5);

} 
while (counter < 544)
{
    counter % 16 => int beat;//modulo to sequence all the Sound buffs
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
    
    //moves the counter up
    counter++;
    //sets the timing of the loop to an eighth note
    eighth => now;//turns all osc's off
    0 => osc1.gain => osc2.gain => osc3.gain;
    //turns the brass off
    lead1.noteOff;
}
while (counter < 608)
    //creates a modulo that i will use as a sequencer
    {
        counter % 16 => int beat;
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
            
            ( pitch / 2 ) => osc2.freq;   
        }
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
            
        }         //moves counter up
        counter++;
        //moves time
        eighth => now;
        //turns OSc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
        //sets value for fade out and fades out, then back in
        leadV - 0.015  => leadV;
        leadV => lead1.gain;
        lead1.noteOff;
    }


    while (counter < 736)
    { 
        //creates another sequencer
        counter % 16 => int beat;
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
        
        counter++;//moves the counter up
        //moves time
        eighth => now;
        //turns the osc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
    
    
    //creates the last loop
    while (counter < 864)
    {
        //randomizes the settings for the lead again
        Math.random2f(0.5,0.95) => lead1.gain;
        panM(1.3) => lead1p.pan;
        Math.random2f(.8, .9) => lead1.slide;
        Math.random2f(10, 12) => lead1.vibratoFreq;
        Math.random2f(.8, 1) => lead1.vibratoGain;
        Math.random2f(.9, 1) => lead1.lip;
        //sequencer
        counter % 16 => int beat;
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
        
        //plays the melody while harmonizing with the three osc's
        if ((beat ==7))
        {
            Std.mtof(tone[Math.random2(0, tone.cap()-1)]) => float tone1;
            0.06 => osc1.gain => osc2.gain => osc3.gain;
            tone1 => osc1.freq;  
            tone1*1.5 => osc2.freq; 
            tone1*2 => osc3.freq; 
        }
        //plays the molody again
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
        
        counter++;//moves the counter up
        
        //moves time
        eighth => now;
        //turns the Osc's off
        0 => osc1.gain => osc2.gain => osc3.gain;
    }
    
    //my functions
    fun float panEx (float f)
    {
        return Math.random2f(-.8,.8)*f;
        
    }
    //my second random pan function
    
    fun float panM (float f)
    {
        return Math.random2f(-.4,.4)*f;   
    }
    
    fun float octave (float originalFreq)
    {
        return (originalFreq*2);   
    }
    //i borrowed this fifth function from the code in class
    fun float fifth (float originalFreq)
    {
        return (originalFreq*1.5);
        
    } 