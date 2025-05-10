   // }

                // Row(
            //   children: [
            //     // Expanded(child: _buildImageContainer(_firstCarImage, true, 'الصورة الأولى')),
            //     // horizontalSpace(12),
            //     // Expanded(child: _buildImageContainer(_secondCarImage, false, 'الصورة الثانية')),
            //   ],
            // ),

    // Widget _buildImageContainer(File? image, bool isFirstImage, String label) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       GestureDetector(
    //         onTap: () => _pickImage(isFirstImage),
    //         child: Container(
    //           width: double.infinity,
    //           height: 200,
    //           decoration: BoxDecoration(color: ColorsManager.lighterGray, borderRadius: BorderRadius.circular(10)),
    //           child:
    //               image != null
    //                   ? Stack(
    //                     children: [
    //                       Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
    //                       Positioned(
    //                         top: 5,
    //                         right: 5,
    //                         child: GestureDetector(
    //                           onTap: () => _removeImage(isFirstImage),
    //                           child: CircleAvatar(
    //                             backgroundColor: Colors.red,
    //                             radius: 15,
    //                             child: Icon(Icons.close, color: Colors.white, size: 20),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                   : Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
    //         ),
    //       ),
    //       verticalSpace(12),
    //       Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    //     ],
    //   );
    // }

    // Future<void> _pickImage(bool isFirstImage) async {
    //   final ImagePicker picker = ImagePicker();
    //   final XFile? pickedFile = await showModalBottomSheet<XFile>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SafeArea(
    //         child: Wrap(
    //           children: [
    //             ListTile(
    //               leading: Icon(Icons.camera),
    //               title: Text('التقاط صورة'),
    //               onTap: () async {
    //                 Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
    //               },
    //             ),
    //             ListTile(
    //               leading: Icon(Icons.photo_library),
    //               title: Text('اختيار من المعرض'),
    //               onTap: () async {
    //                 Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );

    //   if (pickedFile != null) {
    //     setState(() {
    //       if (isFirstImage) {
    //         _firstCarImage = File(pickedFile.path);
    //       } else {
    //         _secondCarImage = File(pickedFile.path);
    //       }
    //     });
    //   }
    // }

    // void _removeImage(bool isFirstImage) {
    //   setState(() {
    //     if (isFirstImage) {
    //       _firstCarImage = null;
    //     } else {
    //       _secondCarImage = null;
    //     }
    //   });
    // }