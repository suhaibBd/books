import 'package:books/domain_layer/books_model.dart';
import 'package:books/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../books_bloc/books_bloc.dart';
import '../books_bloc/books_events.dart';

class AddNewBookScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _authorController = TextEditingController();

  AddNewBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (String? value) {
                  return value?.bookTitleValidate();
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (String? value) {
                  return value?.bookDescValidate();
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (String? value) {
                  return value?.bookAuthorValidate();
                },

              ),
              const SizedBox(height: 16),


              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

debugPrint("teeeeest");

                    context.read<BooksBloc>().add(AddNewBookEvent(BooksModel(
                      title: _titleController.text,
                      desc: _descController.text,
                      author: _authorController.text ,
                      publicationDate: DateTime.now().toString().split(" ").first,

                    )));


                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Book added successfully!')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
