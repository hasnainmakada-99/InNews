import 'package:flutter/material.dart';

enum NewsCategory {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology,
}

extension NewsCategoryExtension on NewsCategory {
  String get displayName {
    switch (this) {
      case NewsCategory.general:
        return 'General';
      case NewsCategory.business:
        return 'Business';
      case NewsCategory.entertainment:
        return 'Entertainment';
      case NewsCategory.health:
        return 'Health';
      case NewsCategory.science:
        return 'Science';
      case NewsCategory.sports:
        return 'Sports';
      case NewsCategory.technology:
        return 'Technology';
    }
  }

  String get value {
    switch (this) {
      case NewsCategory.general:
        return 'general';
      case NewsCategory.business:
        return 'business';
      case NewsCategory.entertainment:
        return 'entertainment';
      case NewsCategory.health:
        return 'health';
      case NewsCategory.science:
        return 'science';
      case NewsCategory.sports:
        return 'sports';
      case NewsCategory.technology:
        return 'technology';
    }
  }

  IconData get icon {
    switch (this) {
      case NewsCategory.general:
        return Icons.public;
      case NewsCategory.business:
        return Icons.business;
      case NewsCategory.entertainment:
        return Icons.movie;
      case NewsCategory.health:
        return Icons.health_and_safety;
      case NewsCategory.science:
        return Icons.science;
      case NewsCategory.sports:
        return Icons.sports;
      case NewsCategory.technology:
        return Icons.computer;
    }
  }

  Color get color {
    switch (this) {
      case NewsCategory.general:
        return Colors.blue;
      case NewsCategory.business:
        return Colors.green;
      case NewsCategory.entertainment:
        return Colors.purple;
      case NewsCategory.health:
        return Colors.red;
      case NewsCategory.science:
        return Colors.orange;
      case NewsCategory.sports:
        return Colors.teal;
      case NewsCategory.technology:
        return Colors.indigo;
    }
  }

  static NewsCategory fromString(String value) {
    return NewsCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => NewsCategory.general,
    );
  }
}