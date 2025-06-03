class MemberResponseModel {
  final bool status;
  final String message;
  final List<MemberModel> data;

  MemberResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MemberResponseModel.fromJson(Map<String, dynamic> json) {
    return MemberResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<MemberModel>.from(json['data'].map((x) => MemberModel.fromJson(x)))
          : [],
    );
  }
}

class MemberModel {
  final MemberId id;
  final AccountInfo accountInfo;

  MemberModel({
    required this.id,
    required this.accountInfo,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: MemberId.fromJson(json['id']),
      accountInfo: AccountInfo.fromJson(json['account_info']),
    );
  }
}

class MemberId {
  final int? personalId;
  final String? googleId;
  final String? facebookId;

  MemberId({
    this.personalId,
    this.googleId,
    this.facebookId,
  });

  factory MemberId.fromJson(Map<String, dynamic> json) {
    return MemberId(
      personalId: json['personal_id'],
      googleId: json['google_id'],
      facebookId: json['facebook_id'],
    );
  }
}

class AccountInfo {
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final String? emailVerifiedAt;
  final Subscription subscription;

  AccountInfo({
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
    this.emailVerifiedAt,
    required this.subscription,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
    );
  }
}

class Subscription {
  final String status;

  Subscription({
    required this.status,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      status: json['status'] ?? 'free',
    );
  }
}