

import 'package:filter_list/filter_list.dart';
import 'package:virtuozy/components/dialogs/chiose_list_dialog/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:filter_list/src/widget/header.dart';
import 'package:virtuozy/components/dialogs/chiose_list_dialog/list_choice.dart';
import 'button_bar.dart';
import 'controll_button.dart';
import 'filter_state.dart';



typedef CValidateSelectedItem<T> = bool Function(List<T>? list, T item);
typedef COnApplyButtonClick<T> = void Function(List<T>? list);
typedef CChoiceChipBuilder<T> = Widget Function(
    BuildContext context, T? item, bool? isSelected);
// typedef ItemSearchDelegate<T> = List<T> Function(List<T>? list, String query);
typedef CSearchPredict<T> = bool Function(T item, String query);
typedef CLabelDelegate<T> = String? Function(T?);
typedef CValidateRemoveItem<T> = List<T> Function(List<T>? list, T item);

class ChoiceListWidget<T extends Object> extends StatelessWidget {
  const ChoiceListWidget({
    Key? key,
    this.themeData,
    this.listData,
    required this.validateSelectedItem,
    this.validateRemoveItem,
    required this.choiceChipLabel,
    required this.onItemSearch,
    this.selectedListData,
    this.onApplyButtonClick,
    this.choiceChipBuilder,
    this.headerCloseIcon,
    this.onCloseWidgetPress,
    this.headlineText,
    this.hideSelectedTextCount = false,
    this.hideSearchField = false,
    this.hideCloseIcon = true,
    this.hideHeader = false,
    this.backgroundColor = Colors.white,
    this.enableOnlySingleSelection = false,
    this.maximumSelectionLength,
    this.allButtonText = 'All',
    this.applyButtonText = 'Apply',
    this.resetButtonText = 'Reset',
    this.selectedItemsText = 'selected items',
    this.controlButtons = const [
      ControlButtonType.All,
      ControlButtonType.Reset
    ],
  }) : super(key: key);

  /// Filter theme
  final FilterListThemeData? themeData;

  /// Pass list containing all data which needs to filter
  final List<T>? listData;

  /// The [selectedListData] is used to preselect the choice chips.
  /// It takes list of object and this list should be subset og [listData]
  final List<T>? selectedListData;
  final Color? backgroundColor;

  final String? headlineText;

  final bool hideSelectedTextCount;
  final bool hideSearchField;

  /// if true then it hides close icon.
  final bool hideCloseIcon;

  /// Widget to close the dialog.
  ///
  /// If widget is not provided then default close icon will be used.
  final Widget? headerCloseIcon;

  /// Function to execute on close widget press. To pass user define function and do a different task with this button rather than close. (Example: Add item to the List.)
  ///
  /// Default is `Navigator.pop(context, null)`
  final void Function()? onCloseWidgetPress;

  /// If true then it hide complete header section.
  final bool? hideHeader;

  /// if [enableOnlySingleSelection] is true then it disabled the multiple selection.
  /// and enabled the single selection model.
  ///
  /// Default value is `false`
  final bool enableOnlySingleSelection;

  /// if `maximumSelectionLength` is not null then it will limit the maximum selection length.
  /// `maximumSelectionLength` should be greater than 0. If `maximumSelectionLength` is less than 0 then it will throw an exception.
  /// Only works when `enableOnlySingleSelection` is false.
  /// Default value is [null]
  final int? maximumSelectionLength;

  /// The `onApplyButtonClick` is a callback which return list of all selected items on apply button click.  if no item is selected then it will return empty list.
  final OnApplyButtonClick<T>? onApplyButtonClick;

  /// The `validateSelectedItem` identifies weather a item is selected or not.
  final ValidateSelectedItem<T> validateSelectedItem; /*required*/

  /// The `validateRemoveItem` identifies if a item should be remove or not and returns the list filtered.
  final ValidateRemoveItem<T>? validateRemoveItem;

  /// The `onItemSearch` is delegate which filter the list on the basis of search field text.
  final SearchPredict<T> onItemSearch; /*required*/

  /// The `choiceChipLabel` is callback which required [String] value to display text on choice chip.
  final LabelDelegate<T> choiceChipLabel; /*required*/

  /// The `choiceChipBuilder` is a builder to design custom choice chip.
  final ChoiceChipBuilder? choiceChipBuilder;

  /// Apply Button Label
  final String? applyButtonText;

  /// Reset Button Label
  final String? resetButtonText;

  /// All Button Label
  final String? allButtonText;

  /// Selected items count text
  final String? selectedItemsText;

  /// {@template control_buttons}
  /// control buttons to show on bottom of dialog along with 'Apply' button.
  ///
  /// If `ControlButtonType.All` is passed then it will show 'All' and 'Apply' button.
  ///
  /// If `ControlButtonType.Reset` is passed then it will show 'Reset' and 'Apply' button.
  ///
  /// Default value is `[ControlButton.All, ControlButton.Reset]`
  ///
  /// If `enableOnlySingleSelection` is true then it will hide 'All' button.
  /// {@endtemplate}
  final List<ControlButtonType> controlButtons;

  Widget _body(BuildContext context) {
    final theme = FilterListTheme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              if (hideHeader!)
                const SizedBox()
              else
                Header(
                  headlineText: headlineText,
                  hideSearchField: hideSearchField,
                  hideCloseIcon: hideCloseIcon,
                  headerCloseIcon: headerCloseIcon,
                  onSearch: (String value) {
                    final stateList = FilterState.of<T>(context).items;

                    // Reset filter list if search box is empty
                    if (value.isEmpty) {
                      FilterState.of<T>(context).items = listData;
                      return;
                    }
                    // Reassign items to filter list when it is empty but local list has data
                    else if (stateList != null &&
                        stateList.isEmpty &&
                        listData != null &&
                        listData!.isNotEmpty) {
                      final isFoundInLocalState =
                      listData!.any((item) => onItemSearch(item, value));

                      if (isFoundInLocalState) {
                        FilterState.of<T>(context).items = listData!
                            .where((item) => onItemSearch(item, value))
                            .toList();
                        return;
                      }
                    }
                    FilterState.of<T>(context)
                        .filter((item) => onItemSearch(item, value));
                  },
                  onCloseWidgetPress: onCloseWidgetPress,
                ),
              if (!hideSelectedTextCount)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CNotifierProvider<FilterState<T>>(
                    builder: (context, state, child) => Text(
                      '${state.selectedItemsCount} $selectedItemsText',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              Expanded(
                child: ListChoice<T>(
                  choiceChipBuilder: choiceChipBuilder,
                  choiceChipLabel: choiceChipLabel,
                  enableOnlySingleSelection: enableOnlySingleSelection,
                  validateSelectedItem: validateSelectedItem,
                  validateRemoveItem: validateRemoveItem,
                  maximumSelectionLength: maximumSelectionLength,
                ),
              ),
            ],
          ),

          // /// Bottom section for control buttons
          ChoiceButtonBar<T>(
            controlButtons: controlButtons,
            maximumSelectionLength: maximumSelectionLength,
            allButtonText: allButtonText,
            applyButtonText: applyButtonText,
            resetButtonText: resetButtonText,
            enableOnlySingleSelection: enableOnlySingleSelection,
            onApplyButtonClick: () {
              final selectedItems = FilterState.of<T>(context).selectedItems;
              if (onApplyButtonClick != null) {
                onApplyButtonClick!.call(selectedItems);
              } else {
                Navigator.pop(context, selectedItems);
              }
            }
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StateProvider<FilterState<T>>(
      value: FilterState<T>(
        allItems: listData,
        selectedItems: selectedListData,
      ),
      child: FilterListTheme(
        theme: themeData ?? FilterListThemeData.light(context),
        child: Builder(
          builder: (BuildContext innerContext) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: _body(innerContext),
            );
          },
        ),
      ),
    );
  }
}
