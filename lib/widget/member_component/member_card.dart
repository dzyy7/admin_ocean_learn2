import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/pages/member/member_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  final MemberController controller;

  const MemberCard({
    super.key,
    required this.member,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: primaryColor.withOpacity(0.1),
                backgroundImage: member.accountInfo.avatar != null 
                    ? NetworkImage(member.accountInfo.avatar!)
                    : null,
                child: member.accountInfo.avatar == null
                    ? Text(
                        member.accountInfo.name.isNotEmpty 
                            ? member.accountInfo.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.accountInfo.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.accountInfo.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: controller.getRoleColor(member.accountInfo.role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.getRoleColor(member.accountInfo.role).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            member.accountInfo.role.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: controller.getRoleColor(member.accountInfo.role),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: controller.getSubscriptionColor(member.accountInfo.subscription.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.getSubscriptionColor(member.accountInfo.subscription.status).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (member.accountInfo.subscription.status == 'premium')
                                Icon(
                                  Icons.star,
                                  size: 12,
                                  color: controller.getSubscriptionColor(member.accountInfo.subscription.status),
                                ),
                              if (member.accountInfo.subscription.status == 'premium')
                                const SizedBox(width: 2),
                              Text(
                                member.accountInfo.subscription.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: controller.getSubscriptionColor(member.accountInfo.subscription.status),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Verified Icon
              if (member.accountInfo.emailVerifiedAt != null)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}