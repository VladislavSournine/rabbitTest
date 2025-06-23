import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaghetti & Over-inheritance Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SpaghettiPage(),
    );
  }
}

abstract class BaseEntity {
  String id = '';
  DateTime createdAt = DateTime.now();

  void baseMethod() {
    print('Base method called');
  }
}

abstract class IdentifiableEntity extends BaseEntity {
  String name = '';
  String description = '';

  void setName(String newName) {
    name = newName;
  }
}

abstract class TimestampedEntity extends IdentifiableEntity {
  DateTime updatedAt = DateTime.now();
  String status = 'active';

  void updateTimestamp() {
    updatedAt = DateTime.now();
  }
}

abstract class CacheableEntity extends TimestampedEntity {
  bool isCached = false;
  String cacheKey = '';

  void invalidateCache() {
    isCached = false;
  }
}

abstract class SerializableEntity extends CacheableEntity {
  Map<String, dynamic> metadata = {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

abstract class ValidatableEntity extends SerializableEntity {
  List<String> validationErrors = [];

  bool validate() {
    validationErrors.clear();
    if (name.isEmpty) validationErrors.add('Name is required');
    return validationErrors.isEmpty;
  }
}

class DataItem extends ValidatableEntity {
  double value = 0.0;
  String category = '';

  @override
  void setName(String newName) {
    super.setName(newName);
    invalidateCache();
    updateTimestamp();
  }
}

abstract class UIComponent extends ValidatableEntity {
  Color backgroundColor = Colors.white;
  double width = 0;
  double height = 0;
}

abstract class InteractiveComponent extends UIComponent {
  bool isEnabled = true;
  VoidCallback? onTap;
}

abstract class AnimatedComponent extends InteractiveComponent {
  Duration animationDuration = Duration(milliseconds: 300);
  Curve animationCurve = Curves.easeInOut;
}

class CustomButton extends AnimatedComponent {
  String buttonText = '';
  IconData? icon;
}

class SpaghettiPage extends StatefulWidget {
  @override
  _SpaghettiPageState createState() => _SpaghettiPageState();
}

class _SpaghettiPageState extends State<SpaghettiPage> {
  List<DataItem> items = [];
  String currentMode = 'view';
  bool isLoading = false;
  int selectedIndex = -1;
  String filterText = '';
  bool showAdvanced = false;
  CustomButton? currentButton;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void processUserAction(String action, {Map<String, dynamic>? params}) {
    if (action == 'load') {
      if (isLoading) return;
      setState(() => isLoading = true);

      if (params != null && params.containsKey('force')) {
        if (params['force'] == true) {
          items.clear();
          for (int i = 0; i < 10; i++) {
            DataItem item = DataItem();
            item.id = 'item_$i';
            item.name = 'Item $i';
            item.value = Random().nextDouble() * 100;
            item.category = i % 3 == 0 ? 'A' : i % 3 == 1 ? 'B' : 'C';
            if (!item.validate()) {
              print('Validation failed: ${item.validationErrors}');
              continue;
            }
            items.add(item);
          }
        } else {
          if (items.length < 5) {
            processUserAction('load', params: {'force': true});
            return;
          } else {
            if (Random().nextBool()) {
              processUserAction('filter', params: {'text': 'random'});
              processUserAction('sort', params: {'field': 'value'});
              processUserAction('display', params: {'mode': 'grid'});
            } else {
              processUserAction('reset');
              processUserAction('load', params: {'force': true});
            }
          }
        }
      } else {
        processUserAction('load', params: {'force': true});
      }

      setState(() => isLoading = false);

    } else if (action == 'filter') {
      if (params == null || !params.containsKey('text')) {
        filterText = '';
      } else {
        filterText = params['text'];
        if (filterText.isNotEmpty) {
          List<DataItem> filtered = [];
          for (DataItem item in items) {
            if (item.name.toLowerCase().contains(filterText.toLowerCase())) {
              filtered.add(item);
            } else if (item.category.toLowerCase().contains(filterText.toLowerCase())) {
              filtered.add(item);
            } else if (item.value.toString().contains(filterText)) {
              filtered.add(item);
            }
          }
          setState(() {
            items = filtered;
          });
          if (filtered.isEmpty) {
            processUserAction('message', params: {'text': 'No results found'});
          } else {
            processUserAction('message', params: {'text': '${filtered.length} items found'});
          }
        } else {
          processUserAction('reset');
        }
      }

    } else if (action == 'sort') {
      if (params != null && params.containsKey('field')) {
        String field = params['field'];
        if (field == 'name') {
          items.sort((a, b) => a.name.compareTo(b.name));
        } else if (field == 'value') {
          items.sort((a, b) => a.value.compareTo(b.value));
        } else if (field == 'category') {
          items.sort((a, b) => a.category.compareTo(b.category));
        } else {
          processUserAction('error', params: {'message': 'Unknown sort field'});
          return;
        }
        setState(() {});
        processUserAction('message', params: {'text': 'Sorted by $field'});
      }

    } else if (action == 'select') {
      if (params != null && params.containsKey('index')) {
        int index = params['index'];
        if (index >= 0 && index < items.length) {
          selectedIndex = index;
          DataItem selected = items[index];
          if (selected.category == 'A') {
            processUserAction('highlight', params: {'color': 'red'});
          } else if (selected.category == 'B') {
            processUserAction('highlight', params: {'color': 'green'});
          } else {
            processUserAction('highlight', params: {'color': 'blue'});
          }
          setState(() {});
          processUserAction('message', params: {'text': 'Selected: ${selected.name}'});
        } else {
          processUserAction('error', params: {'message': 'Invalid index'});
        }
      }

    } else if (action == 'display') {
      if (params != null && params.containsKey('mode')) {
        currentMode = params['mode'];
        setState(() {});
        if (currentMode == 'grid') {
          if (items.length > 6) {
            processUserAction('message', params: {'text': 'Grid view enabled'});
          } else {
            processUserAction('display', params: {'mode': 'list'});
            processUserAction('message', params: {'text': 'Not enough items for grid'});
          }
        } else if (currentMode == 'list') {
          processUserAction('message', params: {'text': 'List view enabled'});
        } else {
          processUserAction('error', params: {'message': 'Unknown display mode'});
        }
      }

    } else if (action == 'reset') {
      setState(() {
        selectedIndex = -1;
        filterText = '';
        currentMode = 'view';
        showAdvanced = false;
      });
      processUserAction('load', params: {'force': true});
      processUserAction('message', params: {'text': 'Reset complete'});

    } else if (action == 'message') {
      if (params != null && params.containsKey('text')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(params['text'])),
        );
      }

    } else if (action == 'error') {
      if (params != null && params.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${params['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } else if (action == 'highlight') {
      if (params != null && params.containsKey('color')) {
        String color = params['color'];
        if (color == 'red') {
          print('Highlighting red');
        } else if (color == 'green') {
          print('Highlighting green');
        } else if (color == 'blue') {
          print('Highlighting blue');
        }
      }

    } else if (action == 'advanced') {
      setState(() {
        showAdvanced = !showAdvanced;
      });
      if (showAdvanced) {
        processUserAction('message', params: {'text': 'Advanced mode enabled'});
        processUserAction('sort', params: {'field': 'value'});
      } else {
        processUserAction('message', params: {'text': 'Simple mode enabled'});
        processUserAction('reset');
      }

    } else {
      processUserAction('error', params: {'message': 'Unknown action: $action'});
    }
  }

  void loadData() {
    processUserAction('load', params: {'force': true});
  }

  Widget buildItemWidget(DataItem item, int index) {
    Color bgColor = Colors.white;
    if (selectedIndex == index) {
      if (item.category == 'A') {
        bgColor = Colors.red.withOpacity(0.3);
      } else if (item.category == 'B') {
        bgColor = Colors.green.withOpacity(0.3);
      } else {
        bgColor = Colors.blue.withOpacity(0.3);
      }
    } else {
      if (item.category == 'A') {
        bgColor = Colors.red.withOpacity(0.1);
      } else if (item.category == 'B') {
        bgColor = Colors.green.withOpacity(0.1);
      } else {
        bgColor = Colors.blue.withOpacity(0.1);
      }
    }

    return GestureDetector(
      onTap: () {
        processUserAction('select', params: {'index': index});
        if (showAdvanced) {
          if (item.value > 50) {
            processUserAction('message', params: {'text': 'High value item selected'});
          } else {
            processUserAction('message', params: {'text': 'Low value item selected'});
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: selectedIndex == index
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.grey, width: 1),
        ),
        child: currentMode == 'grid'
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: selectedIndex == index ? 18 : 16,
              ),
            ),
            SizedBox(height: 4),
            Text('Category: ${item.category}'),
            Text('Value: ${item.value.toStringAsFixed(2)}'),
            if (showAdvanced) ...[
              Text('ID: ${item.id}'),
              Text('Status: ${item.status}'),
              Text('Cached: ${item.isCached}'),
            ],
          ],
        )
            : Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: selectedIndex == index ? 18 : 16,
                ),
              ),
            ),
            Expanded(
              child: Text('${item.category}'),
            ),
            Expanded(
              child: Text('${item.value.toStringAsFixed(2)}'),
            ),
            if (showAdvanced) ...[
              Expanded(child: Text('${item.status}')),
              Expanded(child: Text('${item.isCached ? "Y" : "N"}')),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spaghetti & Over-inheritance Demo'),
        actions: [
          IconButton(
            icon: Icon(showAdvanced ? Icons.visibility_off : Icons.visibility),
            onPressed: () => processUserAction('advanced'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isLoading) {
                      processUserAction('error', params: {'message': 'Already loading'});
                    } else {
                      if (items.isEmpty) {
                        processUserAction('load', params: {'force': true});
                      } else {
                        if (Random().nextBool()) {
                          processUserAction('reset');
                        } else {
                          processUserAction('load', params: {'force': true});
                        }
                      }
                    }
                  },
                  child: Text('Load'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (items.isNotEmpty) {
                      processUserAction('sort', params: {'field': 'name'});
                    } else {
                      processUserAction('error', params: {'message': 'No items to sort'});
                    }
                  },
                  child: Text('Sort'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (currentMode == 'list') {
                      processUserAction('display', params: {'mode': 'grid'});
                    } else {
                      processUserAction('display', params: {'mode': 'list'});
                    }
                  },
                  child: Text(currentMode == 'list' ? 'Grid' : 'List'),
                ),
                Spacer(),
                if (isLoading) CircularProgressIndicator(),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter items...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    if (filterText.isNotEmpty) {
                      processUserAction('filter', params: {'text': ''});
                    } else {
                      processUserAction('message', params: {'text': 'Nothing to clear'});
                    }
                  },
                ),
              ),
              onChanged: (value) {
                if (value.length >= 2) {
                  processUserAction('filter', params: {'text': value});
                } else if (value.isEmpty) {
                  processUserAction('filter', params: {'text': ''});
                }
              },
            ),
          ),

          SizedBox(height: 16),

          Expanded(
            child: items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  Text('No items available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => processUserAction('load', params: {'force': true}),
                    child: Text('Load Data'),
                  ),
                ],
              ),
            )
                : currentMode == 'grid'
                ? GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => buildItemWidget(items[index], index),
            )
                : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) => buildItemWidget(items[index], index),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (items.length >= 20) {
            processUserAction('error', params: {'message': 'Too many items'});
          } else {
            if (selectedIndex >= 0) {
              processUserAction('message', params: {'text': 'Item already selected'});
            } else {
              if (items.isNotEmpty) {
                int randomIndex = Random().nextInt(items.length);
                processUserAction('select', params: {'index': randomIndex});
              } else {
                processUserAction('load', params: {'force': true});
              }
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}