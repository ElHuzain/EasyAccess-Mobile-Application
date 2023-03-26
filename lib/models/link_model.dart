import 'package:flutter/material.dart';

class Link {
  String AppName;
  String Key;
  String AccountId;
  String WebsiteName;
  String WebsiteId;

  Link(
      this.AppName, this.Key, this.AccountId, this.WebsiteName, this.WebsiteId);

  Map<String, String> toJson() => {
        'AppName': AppName,
        'Key': Key,
        'AccountId': AccountId,
        'WebsiteName': WebsiteName,
        'WebsiteId': WebsiteId
      };
}
