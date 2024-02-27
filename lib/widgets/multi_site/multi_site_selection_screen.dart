import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config/multi_site.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import 'multi_site_selection.dart';

class MultiSiteSelectionScreen extends StatefulWidget {
  const MultiSiteSelectionScreen({Key? key}) : super(key: key);

  @override
  State<MultiSiteSelectionScreen> createState() =>
      _MultiSiteSelectionScreenState();
}

class _MultiSiteSelectionScreenState extends State<MultiSiteSelectionScreen> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox(),
        title: Text(S.of(context).selectStore),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: MultiSiteSelection(
                      enabled: !_isApplying,
                      selected: _multiSiteConfig,
                      onChanged: _selectSite),
                ),
              ),
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
                        )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
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
      Navigator.of(context).pop();
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
