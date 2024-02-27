import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:quiver/strings.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../services/service_config.dart';
import '../../../services/services.dart';
import '../models/role.dart';

class MembershipServices {
  final domain = Services().api.domain;

  Future<List<WholesaleRole>> getRoles(BuildContext context) async {
    try {
      var list = <WholesaleRole>[];
      var response = await httpGet(
          Uri.parse('$domain/wp-json/api/flutter_wholesale/roles'));
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        list.add(WholesaleRole(
          key: 'subscriber',
          name: S.of(context).customer,
          desc: S.of(context).thisIsCustomerRole,
        ));
        if (kVendorConfig.vendorRegister &&
            (ServerConfig().typeName.isMultiVendor ||
                ServerConfig().isListeoType)) {
          list.add(WholesaleRole(
            key: 'vendor',
            name: S.of(context).vendor,
            desc: S.of(context).thisIsVendorRole,
          ));
        }
        for (var item in jsonDecode) {
          list.add(WholesaleRole.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(
      {username, email, firstName, lastName, password, selectedRole}) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_wholesale/register'),
          body: convert.jsonEncode({
            'username': username,
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
            'password': password,
            'role': selectedRole,
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return jsonDecode;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }
}
