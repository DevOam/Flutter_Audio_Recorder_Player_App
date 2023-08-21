import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Arrière-plan noir
        appBarTheme: AppBarTheme(
          color: Colors.yellow, // Barre d'applications en jaune
          elevation: 0, // Supprimer l'ombre
        ),
        primaryColor: Colors.orange, // Couleur principale orange
        accentColor: Colors.orange, // Couleur d'accent orange
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Record audioRecord;
  late AudioPlayer audioplayer;
  bool isRecording = false;
  bool isPaused = false;
  String audioPath = '';

  @override
  void initState() {
    audioRecord = Record();
    audioplayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioplayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (await audioRecord.hasPermission()) {
      await audioRecord.start();
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> pauseRecording() async {
    if (isRecording) {
      await audioRecord.pause();
      setState(() {
        isPaused = true;
      });
    }
  }

  Future<void> resumeRecording() async {
    if (isPaused) {
      await audioRecord.resume();
      setState(() {
        isPaused = false;
      });
    }
  }

  Future<void> stopRecording() async {
    String? path = await audioRecord.stop();
    setState(() {
      isRecording = false;
      isPaused = false;
      audioPath = path!;
    });
  }

  Future<void> playRecording() async {
    Source urlSource = UrlSource(audioPath);
    await audioplayer.play(urlSource);
  }




  void clearRecording() {
    setState(() {
      audioPath = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder/Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: clearRecording,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isRecording) Text('Recording...', style: TextStyle(color: Colors.orange)),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording ? Text('Stop Recording') : Text('Start Recording'),
              style: ElevatedButton.styleFrom(primary: Colors.orange),
            ),
            SizedBox(height: 20),
            if (isRecording)
              ElevatedButton(
                onPressed: isPaused ? resumeRecording : pauseRecording,
                child: isPaused ? Text('Resume Recording') : Text('Pause Recording'),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
              ),
            if (!isRecording && audioPath.isNotEmpty)
              ElevatedButton(
                onPressed: playRecording,
                child: Text('Play Recorded Audio'),
                style: ElevatedButton.styleFrom(primary: Colors.orange),
              ),
          ],
        ),
      ),
    );
  }
}
