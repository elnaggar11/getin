import 'package:getincoffee/core/localization/localization_helper.dart';
import 'dart:io';

import 'package:getincoffee/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key, this.onImageSelected});

  final Function(File)? onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipOval(
        child: CircleAvatar(
          radius: 58,
          child: ImagePickerWidget(
            initialImages:
                context.read<EditProfileCubit>().editProfileModel?.image ??
                    LocalizationHelper.tr.unspecified_phrase,
            onImageSelected: (image) {
              if (image != null) {
                onImageSelected!(image);
              }
            },
            builder: (file, initialImages, pickImage) => Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: DefaultImageWidget(
                    file?.path ?? initialImages,
                    width: 116,
                    height: 116,
                    fit: BoxFit.cover,
                    radius: 58,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: 116,
                      height: 33,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
