// lib/screens/stack_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/stack_bloc.dart';
import '../blocs/stack_state.dart';
import '../blocs/stack_event.dart';
import '../widgets/collapsed_view.dart';
import '../widgets/expanded_view.dart';

class StackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bloc = context.read<StackBloc>();
        final currentState = bloc.state;
        if (currentState is StackLoaded &&
            currentState.expandedIndex != null &&
            currentState.expandedIndex! > 0) {
          bloc.add(BackPressed());
          return false; // Prevent default back action
        }
        return true; // Allow default back action (e.g., exit app or screen)
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<StackBloc, StackState>(
          builder: (context, state) {
            if (state is StackLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StackLoaded) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 60, bottom: 20),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final isExpanded = state.expandedIndex == index;
                  return Column(
                    children: [
                      if (isExpanded)
                        ExpandedViewWidget(
                          item: state.items[index],
                          index: index,
                          onCtaPressed: (data) {
                            // Update user inputs in BLoC
                            context.read<StackBloc>().add(
                              UpdateUserInput(index: index, data: data),
                            );

                            // Move to next card if exists
                            if (index < state.items.length - 1) {
                              context
                                  .read<StackBloc>()
                                  .add(ExpandStackItem(index + 1));
                            } else {
                              // Last step completed
                              // Perform final action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Process Completed!'),
                                ),
                              );
                            }
                          },
                          onBack: () {
                            context.read<StackBloc>().add(BackPressed());
                          },
                        )
                      else
                        CollapsedView(
                          item: state.items[index],
                          userInput: state.userInputs[index],
                          onExpand: () {
                            context
                                .read<StackBloc>()
                                .add(ExpandStackItem(index));
                          },
                          index: index,
                        ),
                      SizedBox(height: 8),
                    ],
                  );
                },
              );
            } else if (state is StackError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
