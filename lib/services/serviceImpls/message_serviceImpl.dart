import 'package:fe_mobile_chat_app/model/Message.dart';

class MessageServiceImpl {
  static Message getLastMessage(List<Message> messageList) {
    List<DateTime> dateTimeMessageList = List.empty(growable: true);
    messageList.forEach((mess) {
      dateTimeMessageList.add(mess.sent_date_time!.toLocal());
    });
    DateTime nearestDatetime = findNearestDateTime(dateTimeMessageList);
    List<Message> messages = messageList.where((mess) => mess.sent_date_time?.toLocal() == nearestDatetime).toList();
    return messages.first;
  }

  static DateTime findNearestDateTime(List<DateTime> dateTimeList) {
    DateTime now = DateTime.now();
    DateTime nearestDateTime;

    dateTimeList.sort(
        (a, b) => a.difference(now).abs().compareTo(b.difference(now).abs()));

    nearestDateTime = dateTimeList.first;

    return nearestDateTime;
  }
}
