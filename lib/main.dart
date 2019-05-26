import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

const alarmAudioPath = "sound_alarm.mp3";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRecording = false;
  StreamSubscription<NoiseEvent> _noiseSubscription;
  String _noiseLevel;
  Noise _noise;
  double maxValue = 70;
  double minValue = 30;
  String _message = '';

  TextEditingController minValueCtrl = TextEditingController();
  bool minValueListener = false;

  int lowestValue = 0;
  int highestValue = 999;

  static AudioCache player = new AudioCache();

  @override
  void initState() {
    super.initState();
  }

  void onData(NoiseEvent e) {
    this.setState(() {

      player.play(alarmAudioPath);

      this._noiseLevel = "${e.decibel} dB!";
      if(e.decibel >= this.maxValue){
        this._message = "Over the max threshold";
      }
      if(e.decibel <= this.minValue){
        this._message = "under the min threshold";
      }
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
  }

  void startRecorder() async {
    try {
      _noise = new Noise(500); // New observation every 500 ms
      _noiseSubscription = _noise.noiseStream.listen(onData);
    } on NoiseMeterException catch (exception) {
      print(exception);
    }
  }

  void stopRecorder() async {
    try {
      this._message = "";
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  Text textComponent(String message){
    return Text(
      message,
      style: Theme.of(context).textTheme.display1,
    );
  }

  TextField fieldComponent(String label, Function func){
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: TextInputType.number,
      maxLength: 3,
      onSubmitted: func,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Noise Level Example"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              textComponent("Noise Level",),
              textComponent(_noiseLevel == null ? 'unknown' : '$_noiseLevel'),
              textComponent('$_message'),
              fieldComponent("What is the quiet threshold?",
                      (value) => setState(() => this.minValue = double.parse(value)  )
              ),
              fieldComponent("What is the ear bleeading threshold?",
                      (value) => setState(() => this.maxValue = double.parse(value)  )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!this._isRecording) {
                return this.startRecorder();
    }
              this.stopRecorder();
            },
            child: Icon(this._isRecording ? Icons.stop : Icons.mic)),
      ),
    );
  }
}
