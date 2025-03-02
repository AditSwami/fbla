import 'package:cupertino_refresh/cupertino_refresh.dart';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/components/Unit_box.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:fbla_2025/pages/Units/AddUnitPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.clas});

  final ClassData clas;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  String unitName = '';
  String unitDescirption = '';
  List<UnitData?> _units = [];
  bool _isMember = false;
  bool _isCreator = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadJoinedClasses(context);
    
    if (mounted) {
      setState(() {
        _checkMembershipStatus();
      });
    }
    final units = await Firestore.getUnits(context, widget.clas);
    if (mounted) {
      setState(() {
        _units = units ?? [];
      });
    }
  }

  void _checkMembershipStatus() {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.getCurrentUser();
    final isMember = userProvider.isClassMember(widget.clas.id);
    
    setState(() {
      _isMember = isMember;
      _isCreator = widget.clas.creator == user.id;
      _isLoading = false;
    });
  }

  Future<void> _joinClass() async {
    setState(() => _isLoading = true);
    await context.read<UserProvider>().joinClass(widget.clas, context);
    _checkMembershipStatus();
  }

  Widget _buildJoinButton() {
    if (_isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );
    }

    if(_isCreator){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppUi.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Creator',)
      );
    }

    if (_isMember) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppUi.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Joined',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      );
    }

    return TextButton(
      onPressed: _joinClass,
      style: TextButton.styleFrom(
        backgroundColor: AppUi.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Join',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        toolbarHeight: 120,
        backgroundColor: AppUi.backgroundDark,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 35,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    widget.clas.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SizedBox(
                width: 365,
                child: CupertinoSearchTextField(
                  backgroundColor: AppUi.grey.withAlpha(26),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) => {},
                  onSubmitted: (value) {},
                  placeholder: 'Search',
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0, right: 15.0),
            child: _buildJoinButton(),
          ),

          if(_isCreator)
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0, right: 15),
            child: GestureDetector(
              child: Icon(
                Icons.add,
                color: AppUi.offWhite,
                size: 35,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addunitpage(
                      clas: widget.clas,
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      body: CupertinoRefresh(
        physics: const AlwaysScrollableScrollPhysics(),
        delayDuration: const Duration(seconds: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
              ] +
              _units
                  .map((value) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: UnitBox(
                              unit: value,
                              clas: widget.clas,
                            ),
                          )
                        ],
                      );
                  })
                  .toList(),
        ),
        onRefresh: () async {
          Firestore.getUnits(context, widget.clas).then((unit) {
            setState(() {
              _units = unit!;
            });
          });
        },
      ),
    );
  }
}
