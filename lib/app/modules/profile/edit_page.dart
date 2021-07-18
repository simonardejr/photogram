import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:photogram/app/modules/profile/user_store.dart';

class EditPage extends StatefulWidget {
  final String title;
  const EditPage({Key? key, this.title = 'EditPage'}) : super(key: key);
  @override
  EditPageState createState() => EditPageState();
}
class EditPageState extends ModularState<EditPage, UserStore> {

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _bioFocusNode;

  late final ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: store.user?.displayName);
    _nameFocusNode = FocusNode();
    _bioController = TextEditingController(text: store.bio);
    _bioFocusNode = FocusNode();
    _picker = ImagePicker();
    
    reaction((_) => store.user, (_) {
      _nameController.text = store.user?.displayName ?? '';
    });

    reaction((_) => store.bio, (_) {
      _bioController.text = store.bio ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Observer(builder: (_) {
            if (store.loading) {
              return Container(
                padding: EdgeInsets.only(right: 12),
                child: Center(
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(color: Theme.of(context).buttonColor),
                  ),
                ),
              );
            }
            return TextButton(
              child: Text('Concluir', style: TextStyle(color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  store.updateProfile(
                      displayName: _nameController.text,
                      bio: _bioController.text
                  ).then((_) => Navigator.of(context).pop());
                }
              },
            );
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            child: Observer(
              builder: (_) {
                if(store.user!.photoURL != null && store.user!.photoURL!.isNotEmpty) {
                  return CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(store.user!.photoURL!),
                  );
                }
                return CircleAvatar(
                  radius: 38,
                  backgroundImage: AssetImage('assets/img6.png'),
                );
              },
            ),
          ),
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt_outlined),
                                  SizedBox(width: 16),
                                  Text('Usar Câmera')
                                ],
                              ),
                              onTap: () async {
                                final picturePath = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 50,
                                    maxWidth: 1920,
                                    maxHeight: 1280
                                );
                                if(picturePath != null) {
                                  store.updateProfilePicture(picturePath.path);
                                }

                                Navigator.of(ctx).pop();
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library_outlined),
                                  SizedBox(width: 16),
                                  Text('Escolher da galeria')
                                ],
                              ),
                              onTap: () async {
                                final picturePath = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50,
                                    maxWidth: 1920,
                                    maxHeight: 1280
                                );
                                if(picturePath != null) {
                                  store.updateProfilePicture(picturePath.path);
                                }

                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ),
                      );
                    }
                );
              },
              child: Text('Alterar foto')
          ),
          _editField(label: 'Nome:', controller: _nameController, focusNode: _nameFocusNode),
          _editField(label: 'Bio:', controller: _bioController, focusNode: _bioFocusNode, maxLength: 140)
        ],
      ),
    );
  }
}

class _editField extends StatelessWidget {

  String label;
  TextEditingController controller;
  FocusNode focusNode;
  int? maxLength;

  _editField({required this.label, required this.controller, required this.focusNode, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                    child: Text(label)
                ),
                SizedBox(width: 12,),
                Flexible(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 10,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          );
  }
}
