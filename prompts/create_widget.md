---

## 2. `create_widget.prompt`

**File Name**: `create_widget.prompt`

**Description**: Generates a new widget with a recommended structure.

````md
# create_widget.prompt

You are an expert in Flutter, Dart, and Clean Architecture.

Create a new widget in the `presentation/view/` folder. The widget must:

- Be a stateless or stateful widget (depending on a placeholder).
- Include a constructor with named parameters.
- If the widget has parameters, mark them as `final` in the class.
- Use `const` constructors where possible.

**Template**:

```dart
import 'package:flutter/material.dart';

class {{widget_name.pascalCase()}} extends {{widget_type | default("StatelessWidget")}} {
  const {{widget_name.pascalCase()}}({
    Key? key,
    // TODO: Add parameters here if needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Implement the widget layout
      child: Text('{{widget_name.pascalCase()}}'),
    );
  }
}
```
````
