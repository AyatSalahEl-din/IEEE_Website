
import 'package:hive/hive.dart';
import 'package:ieee_website/hive/settings.dart';
import 'package:ieee_website/hive/user_model.dart';

import '../chatbot/constants.dart';
import 'chat_history.dart';

class Boxes {
  // get the caht history box
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

  // get user box
  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);

  // get settings box
  static Box<Settings> getSettings() =>
      Hive.box<Settings>(Constants.settingsBox);
}