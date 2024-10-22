import 'dart:core';
import 'package:flutter/material.dart' as md;
import 'package:purecord/structs/purecord_structs.dart';

extension GuildIconURL on Guild {
  Uri? get iconURL {
    if (icon != null) {
      return Uri.parse("https://cdn.discordapp.com/icons/$id/$icon.png");
    } else {
      return null;
    }
  }
}

extension UserIconURL on User {
  Uri? get iconURL {
    if (avatar != null) {
      return Uri.parse("https://cdn.discordapp.com/avatars/$id/$avatar.png");
    } else {
      return null;
    }
  }

  Uri? get avatarDecorationURL {
    if (avatarDecorationData?.asset != null) {
      return Uri.parse(
          "https://cdn.discordapp.com/avatar-decoration-presets/${avatarDecorationData!.asset}.png?passthrough=false");
    } else {
      return null;
    }
  }
}

extension ChannelIconURL on Channel {
  Uri? get dmsIconURL {
    if (icon != null) {
      return Uri.parse("https://cdn.discordapp.com/channel-icons/$id/$icon.png");
    } else if (type == 1 && recipients != null && recipients!.isNotEmpty) {
      return recipients!.first.iconURL;
    } else {
      return null;
    }
  }

  md.Image get channelTypeIcon {
    switch (type) {
      case 0:
        return md.Image.asset('assets/icons/number.png'); // Replace with the correct asset path
      case 2:
        return md.Image.asset('assets/icons/mic_fill.png'); // Replace with the correct asset path
      case 5:
        return md.Image.asset('assets/icons/megaphone_fill.png'); // Replace with the correct asset path
      case 13:
        return md.Image.asset('assets/icons/person_wave_2_fill.png'); // Replace with the correct asset path
      case 15:
        return md.Image.asset('assets/icons/bubble_right_fill.png'); // Replace with the correct asset path
      default:
        return md.Image.asset('assets/icons/questionmark.png'); // Replace with the correct asset path
    }
  }
}

extension EmojiImageURL on Emoji {
  Uri? get imageURL {
    if (id != null) {
      return Uri.parse(
          "https://cdn.discordapp.com/emojis/$id${animated == true ? ".gif" : ".png"}");
    } else {
      return null;
    }
  }
}

extension BadgeIconURL on Badge {
  Uri? get iconURL {
    return Uri.parse("https://cdn.discordapp.com/badge-icons/$icon.png?format=gif");
  }
}

extension UserProfileBannerURL on UserProfile {
  Uri? bannerURL(String id) {
    if (banner != null) {
      return Uri.parse(
          "https://cdn.discordapp.com/banners/$id/$banner.png?size=1024&format=png&width=0&height=256");
    } else {
      return null;
    }
  }
}

extension AttachmentPlaceholderURL on Attachment {
  Uri? get placeholderURL {
    return Uri.parse("${url.replaceAll("cdn.discordapp.com", "media.discordapp.net")}format=png");
  }
}
