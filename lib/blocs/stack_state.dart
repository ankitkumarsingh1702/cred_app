// lib/blocs/stack_state.dart
import 'package:equatable/equatable.dart';
import '../models/stack_item.dart';

/// Abstract class representing all possible states.
abstract class StackState extends Equatable {
  const StackState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class StackInitial extends StackState {}

/// State indicating that data is currently being loaded/fetched.
class StackLoading extends StackState {}

/// State indicating that data has been successfully loaded.
class StackLoaded extends StackState {
  final List<StackItem> items;
  final int? expandedIndex; // Index of the currently expanded card. Null if none.
  final Map<int, Map<String, dynamic>> userInputs; // Stores user inputs per card.

  const StackLoaded({
    required this.items,
    this.expandedIndex,
    this.userInputs = const {},
  });

  /// Creates a copy of the current state with optional new values.
  StackLoaded copyWith({
    List<StackItem>? items,
    int? expandedIndex,
    Map<int, Map<String, dynamic>>? userInputs,
  }) {
    return StackLoaded(
      items: items ?? this.items,
      expandedIndex: expandedIndex,
      userInputs: userInputs ?? this.userInputs,
    );
  }

  @override
  List<Object?> get props => [items, expandedIndex, userInputs];
}

/// State indicating that an error has occurred.
class StackError extends StackState {
  final String message;

  const StackError(this.message);

  @override
  List<Object?> get props => [message];
}
