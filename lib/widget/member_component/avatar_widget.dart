import 'package:admin_ocean_learn2/services/avatar_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarPath;
  final double size;
  final String? fallbackText;

  const AvatarWidget({
    super.key,
    this.avatarPath,
    this.size = 48,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.1),
      ),
      child: ClipOval(
        child: avatarPath != null && avatarPath!.isNotEmpty
            ? Image.network(
                AvatarService.getAvatarUrl(avatarPath),
                width: size,
                height: size,
                fit: BoxFit.cover,
                headers: AvatarService.getAuthHeaders(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar();
                },
              )
            : _buildFallbackAvatar(),
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      return Center(
        child: Text(
          fallbackText![0].toUpperCase(),
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      );
    }
    
    return Icon(
      Icons.person,
      size: size * 0.6,
      color: primaryColor.withOpacity(0.7),
    );
  }
}