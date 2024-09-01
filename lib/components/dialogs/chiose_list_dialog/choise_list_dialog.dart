
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/components/dialogs/chiose_list_dialog/choice_list_widget.dart';


class ChoiceListDialog {
  static Future display<T extends Object>(
      BuildContext context, {
        /// Filter theme
        FilterListThemeData? themeData,

        /// Pass list containing all data which needs to filter.
        required List<T> listData,

        /// pass selected list of object
        /// every object on selectedListData should be present in list data.
        List<T>? selectedListData,

        /// Display text on choice chip.
        required CLabelDelegate<T> choiceChipLabel,

        /// identifies weather a item is selected or not.
        required CValidateSelectedItem<T> validateSelectedItem,

        /// The `validateRemoveItem` identifies if a item should be remove or not and returns the list filtered.
        CValidateRemoveItem<T>? validateRemoveItem,

        /// filter list on the basis of search field text.
        /// When text change in search text field then return list containing that text value.
        ///
        ///Check if list has value which matches to text.
        required CSearchPredict<T> onItemSearch,

        /// Return list of all selected items
        required COnApplyButtonClick<T> onApplyButtonClick,

        /// Height of the dialog
        double? height,

        /// Width of the dialog
        double? width,

        /// Border radius of dialog.
        double borderRadius = 20,

        /// Headline text to be display as header of dialog.
        String? headlineText,

        /// Used to hide selected text count.
        bool hideSelectedTextCount = false,

        /// Used to hide search field.
        bool hideSearchField = false,

        /// Used to hide close icon.
        bool hideCloseIcon = false,

        /// Widget to close the dialog.
        ///
        /// If widget is not provided then default close icon will be used.
        final Widget? headerCloseIcon,

        /// Function to execute on close widget press. To pass user define function and do a different task with this button rather than close. (Example: Add item to the List.)
        ///
        /// Default is `Navigator.pop(context, null)`
        final void Function()? onCloseWidgetPress,

        /// Used to hide header.
        bool hideHeader = false,

        /// The `barrierDismissible` argument is used to indicate whether tapping on the barrier will dismiss the dialog.
        ///
        ///  It is true by default and can not be null.
        bool barrierDismissible = true,
        bool useSafeArea = true,
        bool useRootNavigator = true,
        RouteSettings? routeSettings,

        /// if `enableOnlySingleSelection` is true then it disabled the multiple selection.
        /// and enabled the single selection model.
        ///
        /// Default value is [false]
        bool enableOnlySingleSelection = false,

        /// if `maximumSelectionLength` is not null then it will limit the maximum selection length.
        /// `maximumSelectionLength` should be greater than 0. If `maximumSelectionLength` is less than 0 then it will throw an exception.
        /// Only works when `enableOnlySingleSelection` is false.
        /// Default value is [null]
        int? maximumSelectionLength,

        /// Background color of dialog box.
        Color backgroundColor = Colors.white,

        /// Apply Button Label
        String? applyButtonText = 'Apply',

        /// Reset Button Label
        String? resetButtonText = 'Reset',

        /// All Button Label
        String? allButtonText = 'All',

        /// Selected items count text
        String? selectedItemsText = 'selected items',

        /// The amount of padding added to [MediaQueryData.viewInsets] on the outside of the dialog.
        /// This defines the minimum space between the screen's edges and the dialog.
        ///
        /// Defaults to EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0).
        EdgeInsets? insetPadding =
        const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),

        /// The `choiceChipBuilder` is a builder to design custom choice chip.
        ChoiceChipBuilder? choiceChipBuilder,

        /// {@macro control_buttons}
        List<ControlButtonType>? controlButtons,
      }) async {
    height ??= MediaQuery.of(context).size.height * .5;
    width ??= MediaQuery.of(context).size.width;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: insetPadding,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(themeData?.borderRadius ?? 20),
              ),
              child: ChoiceListWidget(
                themeData: themeData,
                listData: listData,
                choiceChipLabel: choiceChipLabel,
                hideHeader: hideHeader,
                headlineText: headlineText,
                onItemSearch: onItemSearch,
                backgroundColor: backgroundColor,
                selectedListData: selectedListData,
                onApplyButtonClick: onApplyButtonClick,
                validateSelectedItem: validateSelectedItem,
                hideSelectedTextCount: hideSelectedTextCount,
                hideCloseIcon: hideCloseIcon,
                headerCloseIcon: headerCloseIcon,
                onCloseWidgetPress: onCloseWidgetPress,
                hideSearchField: hideSearchField,
                choiceChipBuilder: choiceChipBuilder,
                enableOnlySingleSelection: enableOnlySingleSelection,
                selectedItemsText: selectedItemsText,
                applyButtonText: applyButtonText,
                resetButtonText: resetButtonText,
                allButtonText: allButtonText,
                validateRemoveItem: validateRemoveItem,
                maximumSelectionLength: maximumSelectionLength,
                controlButtons: controlButtons ??
                    [ControlButtonType.All, ControlButtonType.Reset],
              ),
            ),
          ),
        );
      },
    );
  }
}
