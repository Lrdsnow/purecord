// messagecomponent.dart
// PureCord API
// Created by Lrdsnow on 10/21/24.

import 'emoji.dart';

class MessageComponent {
  final int type;
  List<MessageComponent>? components; // Action Row
  int? style; // Button, Text Input
  String? label; // Button, Text Input
  Emoji? emoji; // Button
  String? customId; // Button, String Select, Text Input
  String? skuId; // Button
  String? url; // Button
  bool? disabled; // Button, String Select
  List<StringSelectOption>? options; // String Select
  List<int>? channelTypes; // String Select
  String? placeholder; // String Select, Text Input
  List<StringSelectDefaultValue>? defaultValues; // String Select
  int? minValues; // String Select
  int? maxValues; // String Select
  int? minLength; // Text Input
  int? maxLength; // Text Input
  bool? required; // Text Input
  String? value; // Text Input

  MessageComponent({
    required this.type,
    this.components,
    this.style,
    this.label,
    this.emoji,
    this.customId,
    this.skuId,
    this.url,
    this.disabled,
    this.options,
    this.channelTypes,
    this.placeholder,
    this.defaultValues,
    this.minValues,
    this.maxValues,
    this.minLength,
    this.maxLength,
    this.required,
    this.value,
  });

  factory MessageComponent.fromJson(Map<String, dynamic> json) {
    return MessageComponent(
      type: json['type'],
      components: json['components'] != null
          ? List<MessageComponent>.from(
              json['components'].map((x) => MessageComponent.fromJson(x)))
          : null,
      style: json['style'],
      label: json['label'],
      emoji: json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null,
      customId: json['custom_id'],
      skuId: json['sku_id'],
      url: json['url'],
      disabled: json['disabled'],
      options: json['options'] != null
          ? List<StringSelectOption>.from(
              json['options'].map((x) => StringSelectOption.fromJson(x)))
          : null,
      channelTypes: json['channel_types'] != null
          ? List<int>.from(json['channel_types'])
          : null,
      placeholder: json['placeholder'],
      defaultValues: json['default_values'] != null
          ? List<StringSelectDefaultValue>.from(
              json['default_values']
                  .map((x) => StringSelectDefaultValue.fromJson(x)))
          : null,
      minValues: json['min_values'],
      maxValues: json['max_values'],
      minLength: json['min_length'],
      maxLength: json['max_length'],
      required: json['required'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'components': components?.map((e) => e.toJson()).toList(),
      'style': style,
      'label': label,
      'emoji': emoji?.toJson(),
      'custom_id': customId,
      'sku_id': skuId,
      'url': url,
      'disabled': disabled,
      'options': options?.map((e) => e.toJson()).toList(),
      'channel_types': channelTypes,
      'placeholder': placeholder,
      'default_values': defaultValues?.map((e) => e.toJson()).toList(),
      'min_values': minValues,
      'max_values': maxValues,
      'min_length': minLength,
      'max_length': maxLength,
      'required': required,
      'value': value,
    };
  }
}

class StringSelectOption {
  final String label;
  final String value;
  String? description;
  Emoji? emoji; // You might need to define the Emoji class separately

  StringSelectOption({
    required this.label,
    required this.value,
    this.description,
    this.emoji,
  });

  factory StringSelectOption.fromJson(Map<String, dynamic> json) {
    return StringSelectOption(
      label: json['label'],
      value: json['value'],
      description: json['description'],
      emoji: json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'description': description,
      'emoji': emoji?.toJson(),
    };
  }
}

class StringSelectDefaultValue {
  final String id;
  final String type; // Type of value that id represents. Either "user", "role", or "channel"

  StringSelectDefaultValue({
    required this.id,
    required this.type,
  });

  factory StringSelectDefaultValue.fromJson(Map<String, dynamic> json) {
    return StringSelectDefaultValue(
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
