
class Images {
  String? message;
  int? statusCode;
  List<Content>? content;

  Images({this.message, this.statusCode, this.content});

  Images.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["statusCode"] is int) {
      statusCode = json["statusCode"];
    }
    if(json["content"] is List) {
      content = json["content"] == null ? null : (json["content"] as List).map((e) => Content.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["statusCode"] = statusCode;
    if(content != null) {
      _data["content"] = content?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Content {
  String? id;
  String? url;
  String? roomId;

  Content({this.id, this.url, this.roomId});

  Content.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["url"] is String) {
      url = json["url"];
    }
    if(json["roomId"] is String) {
      roomId = json["roomId"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["url"] = url;
    _data["roomId"] = roomId;
    return _data;
  }
}