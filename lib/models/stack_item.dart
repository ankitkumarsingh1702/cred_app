// lib/models/stack_item.dart
import 'package:equatable/equatable.dart';

class StackItem extends Equatable {
  final OpenState openState;
  final ClosedState closedState;
  final String ctaText;

  StackItem({
    required this.openState,
    required this.closedState,
    required this.ctaText,
  });

  factory StackItem.fromJson(Map<String, dynamic> json) {
    return StackItem(
      openState: OpenState.fromJson(json['open_state']),
      closedState: ClosedState.fromJson(json['closed_state']),
      ctaText: json['cta_text'],
    );
  }

  @override
  List<Object?> get props => [openState, closedState, ctaText];
}

class OpenState extends Equatable {
  final Body body;

  OpenState({required this.body});

  factory OpenState.fromJson(Map<String, dynamic> json) {
    return OpenState(
      body: Body.fromJson(json['body']),
    );
  }

  @override
  List<Object?> get props => [body];
}

class ClosedState extends Equatable {
  final Map<String, dynamic> body;

  ClosedState({required this.body});

  factory ClosedState.fromJson(Map<String, dynamic> json) {
    return ClosedState(
      body: Map<String, dynamic>.from(json['body']),
    );
  }

  @override
  List<Object?> get props => [body];
}

class Body extends Equatable {
  final String? title;
  final String? subtitle;
  final CardInfo? card;
  final List<Item>? items;
  final String? footer;

  Body({this.title, this.subtitle, this.card, this.items, this.footer});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      title: json['title'],
      subtitle: json['subtitle'],
      card: json['card'] != null ? CardInfo.fromJson(json['card']) : null,
      items: json['items'] != null
          ? List<Item>.from(json['items'].map((x) => Item.fromJson(x)))
          : null,
      footer: json['footer'],
    );
  }

  @override
  List<Object?> get props => [title, subtitle, card, items, footer];
}

class CardInfo extends Equatable {
  final String header;
  final String description;
  final int maxRange;
  final int minRange;

  CardInfo({
    required this.header,
    required this.description,
    required this.maxRange,
    required this.minRange,
  });

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      header: json['header'],
      description: json['description'],
      maxRange: json['max_range'],
      minRange: json['min_range'],
    );
  }

  @override
  List<Object?> get props => [header, description, maxRange, minRange];
}

class Item extends Equatable {
  final String? emi;
  final String? duration;
  final String? title;
  final String subtitle;
  final String? tag;
  final String? icon;

  Item({
    this.emi,
    this.duration,
    this.title,
    required this.subtitle,
    this.tag,
    this.icon,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // Handle subtitle which can be String or int
    String subtitleValue;
    if (json['subtitle'] is int) {
      subtitleValue = json['subtitle'].toString();
    } else if (json['subtitle'] is String) {
      subtitleValue = json['subtitle'];
    } else {
      subtitleValue = ''; // Default value if neither String nor int
    }

    return Item(
      emi: json['emi'],
      duration: json['duration'],
      title: json['title'],
      subtitle: subtitleValue,
      tag: json['tag'],
      icon: json['icon'],
    );
  }

  @override
  List<Object?> get props => [emi, duration, title, subtitle, tag, icon];
}
