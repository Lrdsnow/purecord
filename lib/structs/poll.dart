// poll.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'emoji.dart';

class Poll {
  final PollMedia question;
  final List<PollAnswer> answers;
  final String? expiry; // ISO8601 timestamp
  final bool allowMultiselect;
  final int layoutType;
  PollResults? results;

  Poll({
    required this.question,
    required this.answers,
    this.expiry,
    required this.allowMultiselect,
    required this.layoutType,
    this.results,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      question: PollMedia.fromJson(json['question']),
      answers: List<PollAnswer>.from(
        json['answers'].map((x) => PollAnswer.fromJson(x)),
      ),
      expiry: json['expiry'],
      allowMultiselect: json['allow_multiselect'],
      layoutType: json['layout_type'],
      results: json['results'] != null ? PollResults.fromJson(json['results']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question.toJson(),
      'answers': answers.map((e) => e.toJson()).toList(),
      'expiry': expiry,
      'allow_multiselect': allowMultiselect,
      'layout_type': layoutType,
      'results': results?.toJson(),
    };
  }
}

class PollAnswer {
  final int answerId;
  final PollMedia pollMedia;

  PollAnswer({
    required this.answerId,
    required this.pollMedia,
  });

  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return PollAnswer(
      answerId: json['answer_id'],
      pollMedia: PollMedia.fromJson(json['poll_media']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer_id': answerId,
      'poll_media': pollMedia.toJson(),
    };
  }
}

class PollMedia {
  String? text;
  Emoji? emoji;

  PollMedia({this.text, this.emoji});

  factory PollMedia.fromJson(Map<String, dynamic> json) {
    return PollMedia(
      text: json['text'],
      emoji: json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'emoji': emoji?.toJson(),
    };
  }
}

class PollResults {
  final bool isFinalized;
  final List<PollAnswerCount> answerCounts;

  PollResults({
    required this.isFinalized,
    required this.answerCounts,
  });

  factory PollResults.fromJson(Map<String, dynamic> json) {
    return PollResults(
      isFinalized: json['is_finalized'],
      answerCounts: List<PollAnswerCount>.from(
        json['answer_counts'].map((x) => PollAnswerCount.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_finalized': isFinalized,
      'answer_counts': answerCounts.map((e) => e.toJson()).toList(),
    };
  }
}

class PollAnswerCount {
  final int id;
  final int count;
  final bool meVoted;

  PollAnswerCount({
    required this.id,
    required this.count,
    required this.meVoted,
  });

  factory PollAnswerCount.fromJson(Map<String, dynamic> json) {
    return PollAnswerCount(
      id: json['id'],
      count: json['count'],
      meVoted: json['me_voted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
      'me_voted': meVoted,
    };
  }
}
