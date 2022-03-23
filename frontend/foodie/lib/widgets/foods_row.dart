import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/food_detail_screen.dart';
import '../providers/foods_provider.dart';

class FoodsRow extends StatefulWidget {
  const FoodsRow({Key? key}) : super(key: key);

  @override
  State<FoodsRow> createState() => _FoodsRowState();
}

class _FoodsRowState extends State<FoodsRow> {
  bool _isinit = true;
  bool _isLoading = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Foods>(context).getfoods(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var list = Provider.of<Foods>(context).items;
    return _isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: const Center(child: CircularProgressIndicator()))
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
                        arguments: list[i].id);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        list[i].image as String,
                        fit: BoxFit.cover,
                      ),
                    ),
                    elevation: 5,
                  ),
                );
              },
              itemCount: list.length,
            ),
          );
  }
}
