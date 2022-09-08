import 'package:flutter/material.dart';
import 'package:toodoo/Cubit/cubit.dart';

Widget CustomButton({
  @required double width,
  @required Color textColor,
  @required Color color,
  @required String text,
  @required void Function() onPressed,
}) =>
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: width,
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  void Function(String) onSubmit,
  ValueChanged<String> onChange,
  void Function() onTap,
  bool isPassword = false,
  @required FormFieldValidator<String> validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  void Function() suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
Widget BuildTask(Map model, context) {
  return Dismissible(
    key: Key(model["id"].toString()),
    background: Container(
        color: Colors.red,
        child: Center(
            child: Text(
          "Delete",
          style: TextStyle(fontSize: 30),
        ))),
    onDismissed: (direction) {
      TodoCubit.get(context).deletedata(id: model['id']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${model['title']} deleted")));
    },
    child: Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${model["title"]}",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffcbcaca))),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "${model["date"]}",
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updatedata(status: 'done', id: model["id"]);
              },
              icon: Icon(
                Icons.done,
              )),
          IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updatedata(status: 'archive', id: model["id"]);
              },
              icon: Icon(
                Icons.archive,
              )),
          Text("${model["time"]}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
        ],
      ),
    ),
  );
}
