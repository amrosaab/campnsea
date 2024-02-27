import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config/multi_site.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import 'multi_site_selection.dart';

mixin MultiSiteMixin {
  Future<void> showMultiSiteSelection(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.75),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Theme.of(ctx).colorScheme.background,
          ),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          child: MultiSiteSelectionContent(
            onBack: () {
              Navigator.pop(ctx);
            },
          ),
        );
      },
    );
  }
}

class MultiSiteSelectionContent extends StatefulWidget {
  const MultiSiteSelectionContent({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;
  @override
  State<MultiSiteSelectionContent> createState() =>
      _MultiSiteSelectionContentState();
}

class _MultiSiteSelectionContentState extends State<MultiSiteSelectionContent> {
  MultiSiteConfig? _multiSiteConfig;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _multiSiteConfig =
            Provider.of<AppModel>(context, listen: false).multiSiteConfig;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              widget.onBack?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.1),
              ),
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(Icons.close),
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: SingleChildScrollView(
            child: MultiSiteSelection(
              enabled: !_isApplying,
              selected: _multiSiteConfig,
              onChanged: _selectSite,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () => _apply(context),
          child: _isApplying
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  S.of(context).apply,
                ),
        )
      ],
    );
  }

  void _selectSite(MultiSiteConfig config) {
    setState(() {
      _multiSiteConfig = config;
    });
  }

  Future _apply(BuildContext context) async {
    try {
      setState(() {
        _isApplying = true;
      });
      await Provider.of<AppModel>(context, listen: false)
          .changeSiteConfig(context, _multiSiteConfig);
      widget.onBack?.call();
    } catch (e) {
      setState(() {
        _isApplying = false;
      });
      await FlashHelper.errorMessage(
        context,
        message: e.toString(),
      );
    }
  }
}
