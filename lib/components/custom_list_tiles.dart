import 'package:flutter/material.dart';

Widget customListTile({
    required String title,
    required String autor,
    required String covorPath,
    onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(

            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(image: AssetImage(covorPath))),
          ),
          const SizedBox(width: 10.0),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Color(0xffF8F1F1), fontSize: 25.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                autor,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Color(0xffE8AA42), fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
