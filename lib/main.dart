import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';


void main() {
runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Create our behavior subject every time the widget is built.
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
      );
    //dispose of the old subject when the widget is rebuilt.  
    useEffect(
      ()=> subject.close,
      [subject],
    );  
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: subject.stream.distinct().debounceTime(const Duration(seconds: 1)),
          initialData: 'Please start typing...',
          builder: (context, snapshot) {
            return Text(snapshot.requireData); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: subject.sink.add,
        ),
      ),
      
      );
  }
}