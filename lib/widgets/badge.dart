import 'package:flutter/material.dart';
class Badge extends StatelessWidget {

  final  Widget child;
 final  String valu;
 final  Color color;

  const Badge({
    @required this.valu,
    @required this.color,
    this.child});
  @override
  Widget build(BuildContext context) {
return Stack(
  alignment: Alignment.center,
  children: [
child,

   Positioned(right:8,top: 8, child: Container(padding: EdgeInsets.all(2.0),decoration: BoxDecoration(

     borderRadius: BorderRadius.circular(10.0),
     color: color != null?color:Theme.of(context).accentColor,
   ),
     constraints: BoxConstraints(minHeight: 16,maxHeight:16 ,),
     child: Text(valu,style: TextStyle(fontSize: 10,),textAlign: TextAlign.center,),

   ),),
    
  ],
);


  }
}
