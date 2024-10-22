// embed.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

class Embed {
  String? title;
  String? type;
  String? description;
  String? url;
  String? timestamp; // ISO8601 timestamp
  int? color;
  EmbedFooter? footer;
  EmbedImage? image;
  EmbedThumbnail? thumbnail;
  EmbedVideo? video;
  EmbedProvider? provider;
  EmbedAuthor? author;
  List<EmbedField>? fields;

  Embed({
    this.title,
    this.type,
    this.description,
    this.url,
    this.timestamp,
    this.color,
    this.footer,
    this.image,
    this.thumbnail,
    this.video,
    this.provider,
    this.author,
    this.fields,
  });

  factory Embed.fromJson(Map<String, dynamic> json) {
    return Embed(
      title: json['title'],
      type: json['type'],
      description: json['description'],
      url: json['url'],
      timestamp: json['timestamp'],
      color: json['color'],
      footer: json['footer'] != null ? EmbedFooter.fromJson(json['footer']) : null,
      image: json['image'] != null ? EmbedImage.fromJson(json['image']) : null,
      thumbnail: json['thumbnail'] != null ? EmbedThumbnail.fromJson(json['thumbnail']) : null,
      video: json['video'] != null ? EmbedVideo.fromJson(json['video']) : null,
      provider: json['provider'] != null ? EmbedProvider.fromJson(json['provider']) : null,
      author: json['author'] != null ? EmbedAuthor.fromJson(json['author']) : null,
      fields: (json['fields'] as List<dynamic>?)?.map((e) => EmbedField.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'description': description,
      'url': url,
      'timestamp': timestamp,
      'color': color,
      'footer': footer?.toJson(),
      'image': image?.toJson(),
      'thumbnail': thumbnail?.toJson(),
      'video': video?.toJson(),
      'provider': provider?.toJson(),
      'author': author?.toJson(),
      'fields': fields?.map((e) => e.toJson()).toList(),
    };
  }
}

class EmbedThumbnail {
  String url;
  String? proxyUrl;
  int? height;
  int? width;

  EmbedThumbnail({
    required this.url,
    this.proxyUrl,
    this.height,
    this.width,
  });

  factory EmbedThumbnail.fromJson(Map<String, dynamic> json) {
    return EmbedThumbnail(
      url: json['url'],
      proxyUrl: json['proxy_url'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'proxy_url': proxyUrl,
      'height': height,
      'width': width,
    };
  }
}

class EmbedVideo {
  String? url;
  String? proxyUrl;
  int? height;
  int? width;

  EmbedVideo({
    this.url,
    this.proxyUrl,
    this.height,
    this.width,
  });

  factory EmbedVideo.fromJson(Map<String, dynamic> json) {
    return EmbedVideo(
      url: json['url'],
      proxyUrl: json['proxy_url'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'proxy_url': proxyUrl,
      'height': height,
      'width': width,
    };
  }
}

class EmbedImage {
  String url;
  String? proxyUrl;
  int? height;
  int? width;

  EmbedImage({
    required this.url,
    this.proxyUrl,
    this.height,
    this.width,
  });

  factory EmbedImage.fromJson(Map<String, dynamic> json) {
    return EmbedImage(
      url: json['url'],
      proxyUrl: json['proxy_url'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'proxy_url': proxyUrl,
      'height': height,
      'width': width,
    };
  }
}

class EmbedProvider {
  String? name;
  String? url;

  EmbedProvider({
    this.name,
    this.url,
  });

  factory EmbedProvider.fromJson(Map<String, dynamic> json) {
    return EmbedProvider(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class EmbedAuthor {
  String name;
  String? url;
  String? iconUrl;
  String? proxyIconUrl;

  EmbedAuthor({
    required this.name,
    this.url,
    this.iconUrl,
    this.proxyIconUrl,
  });

  factory EmbedAuthor.fromJson(Map<String, dynamic> json) {
    return EmbedAuthor(
      name: json['name'],
      url: json['url'],
      iconUrl: json['icon_url'],
      proxyIconUrl: json['proxy_icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'icon_url': iconUrl,
      'proxy_icon_url': proxyIconUrl,
    };
  }
}

class EmbedFooter {
  String text;
  String? iconUrl;
  String? proxyIconUrl;

  EmbedFooter({
    required this.text,
    this.iconUrl,
    this.proxyIconUrl,
  });

  factory EmbedFooter.fromJson(Map<String, dynamic> json) {
    return EmbedFooter(
      text: json['text'],
      iconUrl: json['icon_url'],
      proxyIconUrl: json['proxy_icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'icon_url': iconUrl,
      'proxy_icon_url': proxyIconUrl,
    };
  }
}

class EmbedField {
  String name;
  String value;
  bool? inline;

  EmbedField({
    required this.name,
    required this.value,
    this.inline,
  });

  factory EmbedField.fromJson(Map<String, dynamic> json) {
    return EmbedField(
      name: json['name'],
      value: json['value'],
      inline: json['inline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'inline': inline,
    };
  }
}
