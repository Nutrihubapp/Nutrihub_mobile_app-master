class HelpAndSupportModel {
  String? systemEmail;
  String? systemPhone;
  List<HelpAndSupport>? helpAndSupport;
  String? message;
  int? status;
  bool? validity;

  HelpAndSupportModel(
      {this.systemEmail,
      this.systemPhone,
      this.helpAndSupport,
      this.message,
      this.status,
      this.validity});

  HelpAndSupportModel.fromJson(Map<String, dynamic> json) {
    systemEmail = json['system_email'];
    systemPhone = json['system_phone'];
    if (json['help_and_support'] != null) {
      helpAndSupport = <HelpAndSupport>[];
      json['help_and_support'].forEach((v) {
        helpAndSupport!.add(HelpAndSupport.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system_email'] = systemEmail;
    data['system_phone'] = systemPhone;
    if (helpAndSupport != null) {
      data['help_and_support'] =
          helpAndSupport!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class HelpAndSupport {
  String? helpAndSupportId;
  String? question;
  String? answer;
  String? status;

  HelpAndSupport(
      {this.helpAndSupportId, this.question, this.answer, this.status});

  HelpAndSupport.fromJson(Map<String, dynamic> json) {
    helpAndSupportId = json['help_and_support_id'];
    question = json['question'];
    answer = json['answer'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['help_and_support_id'] = helpAndSupportId;
    data['question'] = question;
    data['answer'] = answer;
    data['status'] = status;
    return data;
  }
}
