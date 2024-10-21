// lib/blocs/stack_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'stack_event.dart';
import 'stack_state.dart';
import '../repositories/stack_repository.dart';

/// BLoC class managing the state of the stack of cards.
class StackBloc extends Bloc<StackEvent, StackState> {
  final StackRepository repository;

  /// Constructor requires a [StackRepository] to fetch data.
  StackBloc({required this.repository}) : super(StackInitial()) {
    // Register event handlers.
    on<FetchStackItems>(_onFetchStackItems);
    on<ExpandStackItem>(_onExpandStackItem);
    on<CollapseStackItem>(_onCollapseStackItem);
    on<BackPressed>(_onBackPressed);
    on<UpdateUserInput>(_onUpdateUserInput);
  }

  /// Handles the [FetchStackItems] event.
  void _onFetchStackItems(
      FetchStackItems event, Emitter<StackState> emit) async {
    emit(StackLoading());
    try {
      final items = await repository.getStackItems();
      if (items.length < 2 || items.length > 4) {
        emit(StackError('Number of items must be between 2 and 4.'));
      } else {
        // Initially, expand the first card (index 0).
        emit(StackLoaded(items: items, expandedIndex: 0, userInputs: {}));
      }
    } catch (e) {
      emit(StackError(e.toString()));
    }
  }

  /// Handles the [ExpandStackItem] event.
  void _onExpandStackItem(
      ExpandStackItem event, Emitter<StackState> emit) {
    final currentState = state;
    if (currentState is StackLoaded) {
      emit(currentState.copyWith(expandedIndex: event.index));
    }
  }

  /// Handles the [CollapseStackItem] event.
  void _onCollapseStackItem(
      CollapseStackItem event, Emitter<StackState> emit) {
    final currentState = state;
    if (currentState is StackLoaded) {
      // Only collapse if the current expanded index matches the event's index.
      if (currentState.expandedIndex == event.index) {
        emit(currentState.copyWith(expandedIndex: null));
      }
    }
  }

  /// Handles the [BackPressed] event to navigate to the previous card.
  void _onBackPressed(BackPressed event, Emitter<StackState> emit) {
    final currentState = state;
    if (currentState is StackLoaded) {
      if (currentState.expandedIndex != null &&
          currentState.expandedIndex! > 0) {
        // Move to the previous card.
        emit(currentState.copyWith(
            expandedIndex: currentState.expandedIndex! - 1));
      }
      // If expandedIndex is 0 or null, you might choose to handle exit or other logic.
    }
  }

  /// Handles the [UpdateUserInput] event to store user selections.
  void _onUpdateUserInput(
      UpdateUserInput event, Emitter<StackState> emit) {
    final currentState = state;
    if (currentState is StackLoaded) {
      // Create a mutable copy of userInputs.
      final updatedUserInputs =
      Map<int, Map<String, dynamic>>.from(currentState.userInputs);
      // Update the specific card's user input.
      updatedUserInputs[event.index] = event.data;
      emit(currentState.copyWith(userInputs: updatedUserInputs));
    }
  }
}
