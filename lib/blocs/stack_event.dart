// lib/blocs/stack_event.dart
import 'package:equatable/equatable.dart';

/// Abstract class representing all possible events.
abstract class StackEvent extends Equatable {
  const StackEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch stack items from the repository/API.
class FetchStackItems extends StackEvent {}

/// Event to expand a specific stack item/card based on its index.
class ExpandStackItem extends StackEvent {
  final int index;

  const ExpandStackItem(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event to collapse a specific stack item/card based on its index.
class CollapseStackItem extends StackEvent {
  final int index;

  const CollapseStackItem(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event triggered when the user presses the back button to navigate to the previous card.
class BackPressed extends StackEvent {}

/// Event to update user input data for a specific card based on its index.
class UpdateUserInput extends StackEvent {
  final int index;
  final Map<String, dynamic> data;

  const UpdateUserInput({required this.index, required this.data});

  @override
  List<Object?> get props => [index, data];
}
