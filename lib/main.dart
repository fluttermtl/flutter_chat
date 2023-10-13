import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_message.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // We sign the user in anonymously, meaning they get a user ID without having
  // to provide credentials. While this doesn't allow us to identify the user,
  // this would, for example, still allow us to associate data in the database
  // with each user.
  await FirebaseAuth.instance.signInAnonymously();
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
  final messages = List<ChatMessage>.empty(growable: true);

  bool _isTextValidated = true;

  void _sendMessage() {
    if (textMessageController.text.isEmpty) {
      setState(() {
        _isTextValidated = false;
      });
    } else {
      setState(() {
        final chatMessage = ChatMessage(
          time: DateTime.now().millisecondsSinceEpoch,
          message: textMessageController.text,
        );
        FirebaseFirestore.instance.collection('chat').add(chatMessage.toJson());
        messages.insert(
          0,
          chatMessage,
        );
      });
      textMessageController.clear();
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
                itemCount: messages.length,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.indigo),
                      child: Text(messages[index].timestamp),
                    ),
                    title: Text(messages[index].message),
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
