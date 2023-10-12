import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textMessageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = List<Map<String, dynamic>>.empty(growable: true);

  bool _isTextValidated = true;

  void _sendMessage() {
    if (textMessageController.text.isEmpty) {
      setState(() {
        _isTextValidated = false;
      });
    } else {
      setState(() {
        messages.insert(
          0,
          {
            'message': textMessageController.text,
            'timestamp': DateTime.now().millisecondsSinceEpoch
          },
        );
      });
      textMessageController.clear();
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (context, i) {
                  var timestamp = DateTime.fromMillisecondsSinceEpoch(
                      messages[i]['timestamp']);
                  return ListTile(
                    leading: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.indigo),
                      child: Text('${timestamp.hour}:${timestamp.minute}'),
                    ),
                    title: Text('${messages[i]['message']}'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: textMessageController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your message',
                  errorText:
                      _isTextValidated ? null : 'Message can not be empty',
                ),
                onChanged: (value) {
                  setState(() {
                    _isTextValidated = true;
                  });
                },
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
