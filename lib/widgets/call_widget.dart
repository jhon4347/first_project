import 'package:flutter/material.dart';

class CallWidget extends StatelessWidget {
  final bool isIncomingCall; // Indicates if the call is incoming
  final String callerName; // Name of the person calling
  final Function onAnswer; // Function to handle answering the call
  final Function onReject; // Function to handle rejecting the call
  final Function onEndCall; // Function to end the call

  const CallWidget({
    super.key,
    required this.isIncomingCall,
    required this.callerName,
    required this.onAnswer,
    required this.onReject,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isIncomingCall ? 'Incoming Call' : 'Ongoing Call'),
        backgroundColor: isIncomingCall ? Colors.red : Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display caller name
            Text(
              callerName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isIncomingCall ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 20),

            // Display call status
            Text(
              isIncomingCall ? 'You have an incoming call' : 'Ongoing Call',
              style: TextStyle(
                fontSize: 18,
                color: isIncomingCall ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 40),

            // Show different actions based on call status
            if (isIncomingCall)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reject button
                  IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.red,
                    onPressed: () => onReject(),
                    iconSize: 50,
                  ),
                  SizedBox(width: 30),
                  // Answer button
                  IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () => onAnswer(),
                    iconSize: 50,
                  ),
                ],
              )
            else
              // End Call button
              IconButton(
                icon: Icon(Icons.call_end),
                color: Colors.red,
                onPressed: () => onEndCall(),
                iconSize: 60,
              ),
          ],
        ),
      ),
    );
  }
}
