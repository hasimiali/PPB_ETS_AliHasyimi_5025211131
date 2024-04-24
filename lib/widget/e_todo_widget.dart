import 'package:flutter/material.dart';
import 'package:ets/model/todo.dart';
import 'package:image_field/image_field.dart';

class CreateTodoWidget extends StatefulWidget {
  final Todo? todo;
  final ValueChanged<String> onSubmit;

  const CreateTodoWidget({
    Key? key,
    this.todo,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
}

class _CreateTodoWidgetState extends State<CreateTodoWidget> {
  final controller_tittle = TextEditingController();
  final controller_description = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller_tittle.text = widget.todo?.title ?? '';
    controller_description.text = widget.todo?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return AlertDialog(
      title: Text(isEditing? 'Edit Movie' : 'Add Movie'),
      content: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: controller_tittle,
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (value) => value != null && value.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                autofocus: true,
                controller: controller_description,
                decoration: const InputDecoration(hintText: 'Description'),
                validator: (value) => value != null && value.isEmpty ? 'Description is required' : null,
              ),
              // ImageField(
              //     texts: const {
              //       'fieldFormText': 'Upload to server',
              //       'titleText': 'Upload to server'
              //     },
              //     ),

            ],
          ),



      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onSubmit(controller_tittle.text);
              }
            },
            child: const Text('OK')
        ),
      ],
    );
  }
}
