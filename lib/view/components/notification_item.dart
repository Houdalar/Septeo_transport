import 'package:flutter/material.dart';
import 'package:septeo_transport/model/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatefulWidget {
  final notification notif;

  NotificationItem({required this.notif});

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/avatar.png"),
                        radius: 20,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(Icons.check_circle,
                            color: Colors.blue, size: 15),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14), // Default style
                            children: <TextSpan>[
                              const TextSpan(text: "Driver of bus "),
                              TextSpan(
                                text: widget.notif.busNumber,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: " sent you "),
                              TextSpan(
                                text: isExpanded
                                    ? widget.notif.message
                                    : "${widget.notif.message.split(" ").take(10).join(" ")}...",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          timeago.format(widget.notif.timeSent),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
