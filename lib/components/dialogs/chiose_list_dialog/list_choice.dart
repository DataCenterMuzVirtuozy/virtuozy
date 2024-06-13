

import 'package:filter_list/filter_list.dart';
import 'package:flutter/widgets.dart';
import 'package:filter_list/src/widget/choice_chip_widget.dart';
import 'choice_list_widget.dart';
import 'choice_provider.dart';
import 'filter_state.dart';

class ListChoice<T> extends StatelessWidget {
  const ListChoice({
    Key? key,
    required this.validateSelectedItem,
    this.choiceChipBuilder,
    this.choiceChipLabel,
    this.enableOnlySingleSelection = false,
    this.validateRemoveItem,
    this.maximumSelectionLength,
  }) : super(key: key);
  final CValidateSelectedItem<T> validateSelectedItem;
  final CChoiceChipBuilder? choiceChipBuilder;
  final CLabelDelegate<T>? choiceChipLabel;
  final bool enableOnlySingleSelection;
  final CValidateRemoveItem<T>? validateRemoveItem;
  final int? maximumSelectionLength;

  List<Widget> _buildChoiceList(BuildContext context) {
    final theme = FilterListTheme.of(context).controlBarButtonTheme;
    final state = StateProvider.of<FilterState<T>>(context);
    final items = state.items;
    final selectedListData = state.selectedItems;
    if (items == null || items.isEmpty) {
      return const <Widget>[];
    }
    final List<Widget> choices = [];
    for (final item in items) {
      final selected = validateSelectedItem(selectedListData, item);

      // Check if maximum selection length reached
      final maxSelectionReached = maximumSelectionLength != null &&
          state.selectedItems != null &&
          state.selectedItems!.length >= maximumSelectionLength!;
      choices.add(
        ChoiceChipWidget(
          choiceChipBuilder: choiceChipBuilder,
          disabled: maxSelectionReached,
          item: item,
          onSelected: (value) {
            if (enableOnlySingleSelection) {
              state.clearSelectedList();
              state.addSelectedItem(item);
            } else {
              if (selected) {
                if (validateRemoveItem != null) {
                  final shouldDelete =
                  validateRemoveItem!(selectedListData, item);
                  state.selectedItems = shouldDelete;
                } else {
                  state.removeSelectedItem(item);
                }
              } else {
                // Add maximum selection length check
                if (maxSelectionReached && !selected) {
                  return;
                }
                state.addSelectedItem(item);
              }
            }
          },
          selected: selected,
          text: choiceChipLabel!(item),
        ),
      );
    }
    choices.add(
      SizedBox(
        height: theme.height + 20,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FilterListTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        child: CNotifierProvider<FilterState<T>>(
          builder: (
              BuildContext context,
              FilterState<T> state,
              Widget? child,
              ) {
            return Wrap(
              direction: Axis.vertical,
              alignment: theme.wrapAlignment,
              crossAxisAlignment: theme.wrapCrossAxisAlignment,
              runSpacing: theme.wrapSpacing,
              children: _buildChoiceList(context),
            );
          },
        ),
      ),
    );
  }
}
