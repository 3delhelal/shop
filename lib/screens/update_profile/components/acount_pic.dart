import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountPic extends StatelessWidget {
  final BuildContext context;
  final String imageUrl;
  final Function(BuildContext context, ImageSource) press;

  const AccountPic({
    Key? key,
    required this.context,
    required this.imageUrl,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(_) {
    var size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              shape: MaterialStateProperty.all(const CircleBorder())),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(),
                content: SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.network(imageUrl),
                ),
              ),
            );
          },
          child: Hero(
            tag: "Photo",
            child: CircleAvatar(
              foregroundColor: Colors.green,
              minRadius: 40,
              maxRadius: 65,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: 0,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.01)),
                shape: MaterialStateProperty.all(
                  const CircleBorder(
                    side: BorderSide(color: Colors.black38),
                  ),
                ),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    context: context,
                    builder: (ctx) => Container(
                          constraints: BoxConstraints(
                              minHeight: size.height * 0.2,
                              maxHeight: size.height * 0.5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: const Text("Edit Profile picture"),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    TextButton.icon(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(left: 15)),
                                      ),
                                      icon: const Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                      label: const Text("Camera"),
                                      onPressed: () {
                                        press(context, ImageSource.camera);
                                      },
                                    ),
                                    TextButton.icon(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(left: 15)),
                                      ),
                                      icon: const Icon(
                                        Icons.photo,
                                      ),
                                      label: const Text("Gellary"),
                                      onPressed: () {
                                        press(context, ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
              }),
        )
      ],
    );
  }
}
