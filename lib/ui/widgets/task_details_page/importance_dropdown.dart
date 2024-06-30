import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/models/importance.dart';

class ImportanceDropdown extends StatefulWidget {
  const ImportanceDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Importance value;
  final Function(Importance) onChanged;

  @override
  State<ImportanceDropdown> createState() => _ImportanceDropdownState();
}

class _ImportanceDropdownState extends State<ImportanceDropdown> {
  late Importance value = widget.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.importance,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 164,
          child: ButtonTheme(
            // alignedDropdown: true,

            child: DropdownButtonHideUnderline(
              child: DropdownButton<Importance>(
                value: value,
                icon: const SizedBox(),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                elevation: 3,
                items: [
                  DropdownMenuItem<Importance>(
                    value: Importance.basic,
                    child: Text(
                      AppLocalizations.of(context)!.importanceBasic,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem<Importance>(
                    value: Importance.low,
                    child: Text(
                      AppLocalizations.of(context)!.importanceLow,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem<Importance>(
                    value: Importance.important,
                    child: Text(
                      AppLocalizations.of(context)!.importanceHigh,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
                onChanged: (Importance? value) {
                  if (value != null) {
                    setState(() {
                      this.value = value;
                      widget.onChanged(value);
                    });
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
