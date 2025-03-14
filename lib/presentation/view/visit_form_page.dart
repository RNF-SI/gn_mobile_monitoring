import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

class VisitFormPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final BaseVisit? visit; // En mode édition, visite existante

  const VisitFormPage({
    super.key,
    required this.site,
    required this.visitConfig,
    this.visit,
  });

  @override
  VisitFormPageState createState() => VisitFormPageState();
}

class VisitFormPageState extends ConsumerState<VisitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  final Map<String, TextEditingController> _textControllers = {};
  late bool _isEditMode;
  bool _isLoading = false;
  bool _chainInput = false; // pour "enchaîner les saisies"

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.visit != null;
    // Si la config indique que l'enchaînement est possible, on initialise la bascule
    _chainInput = widget.visitConfig.chained ?? false;

    // En mode édition, pré-remplir le formulaire
    if (_isEditMode && widget.visit != null) {
      _initFormValuesFromVisit(widget.visit!);
    }
  }

  void _initFormValuesFromVisit(BaseVisit visit) {
    _formValues['visit_date_min'] = visit.visitDateMin;
    _textControllers['visit_date_min'] = TextEditingController(
      text: visit.visitDateMin != null
          ? DateTime.parse(visit.visitDateMin).toIso8601String().split('T')[0]
          : '',
    );
    _formValues['comments'] = visit.comments;
    _textControllers['comments'] =
        TextEditingController(text: visit.comments ?? '');
    // Initialiser d'autres champs si nécessaire en fonction de la config
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Réinitialiser le formulaire en cas d'enchaînement
  void _resetForm() {
    _formKey.currentState?.reset();
    _formValues.clear();
    _textControllers.forEach((key, controller) {
      controller.clear();
    });
    // Vous pouvez ici conserver certaines valeurs (par exemple, la sélection du site) si besoin.
  }

  // Simulation d'une suppression avec confirmation
  Future<void> _deleteVisit() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content:
            const Text("Êtes-vous sûr de vouloir supprimer cette visite ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });
      // Simuler la suppression (remplacer par votre appel API)
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visite supprimée avec succès (Simulation)'),
          ),
        );
      }
    }
  }

  // Sauvegarde (création ou mise à jour)
  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Préparer les données du formulaire depuis _formValues, par exemple :
      // final dataToSend = {..._formValues, ...autresChamps};
      await Future.delayed(
          const Duration(seconds: 2)); // Simulation d'appel asynchrone

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Si enchaînement et création, réinitialiser le formulaire
        if (_chainInput && !_isEditMode) {
          _resetForm();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Visite enregistrée. Vous pouvez saisir la suivante.'),
            ),
          );
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode
                  ? 'Visite mise à jour avec succès (Simulation)'
                  : 'Visite créée avec succès (Simulation)'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, GenericFieldConfig> genericFields =
        widget.visitConfig.generic ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? 'Modifier la visite'
            : widget.visitConfig.label ?? 'Nouvelle visite'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Supprimer la visite',
              onPressed: _deleteVisit,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Option de bascule pour enchaîner les saisies
                  if (widget.visitConfig.chained == true)
                    Row(
                      children: [
                        const Text('Enchaîner les saisies'),
                        Switch(
                          value: _chainInput,
                          onChanged: (val) {
                            setState(() {
                              _chainInput = val;
                            });
                          },
                        ),
                      ],
                    ),

                  // Informations générales
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informations générales',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDateField(
                              'visit_date_min', 'Date de la visite', true),
                          _buildTextField('comments', 'Commentaires',
                              maxLines: 3),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Champs spécifiques (dynamiques)
                  if (widget.visitConfig.specific != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations spécifiques',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSpecificFieldsList(
                                [widget.visitConfig.specific]),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Boutons d'action
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(
                              _isEditMode ? 'Mettre à jour' : 'Enregistrer'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Nouvelle fonction pour itérer directement sur une liste de définitions "specific"
  Widget _buildSpecificFieldsList(List<dynamic> fieldDefinitions) {
    // Si le premier élément est une Map, on traite comme une Map de configurations
    if (fieldDefinitions.length == 1 &&
        fieldDefinitions[0] is Map<String, dynamic>) {
      final Map<String, dynamic> fieldsMap = fieldDefinitions[0];
      return Column(
        children: fieldsMap.entries.map<Widget>((entry) {
          final String fieldKey = entry.key;
          final Map<String, dynamic> fieldConfig = entry.value;
          final String fieldLabel = fieldConfig['attribut_label'] ?? fieldKey;
          final bool isRequired = fieldConfig['required'] == true;
          final String typeWidget = fieldConfig['type_widget'] ?? 'text';

          switch (typeWidget) {
            case 'date':
              return _buildDateField(fieldKey, fieldLabel, isRequired);
            case 'text':
              return _buildTextField(fieldKey, fieldLabel,
                  required: isRequired);
            case 'textarea':
              return _buildTextField(fieldKey, fieldLabel,
                  required: isRequired, maxLines: 3);
            case 'number':
              return _buildNumberField(fieldKey, fieldLabel, isRequired);
            case 'select':
              if (fieldConfig['values'] is List) {
                final List<MapEntry<String, String>> options =
                    (fieldConfig['values'] as List)
                        .map<MapEntry<String, String>>((value) =>
                            MapEntry(value.toString(), value.toString()))
                        .toList();
                return _buildSelectField(
                    fieldKey, fieldLabel, isRequired, options);
              }
              break;
            case 'time':
              return _buildTextField(fieldKey, fieldLabel,
                  required: isRequired); // TODO: Implement proper time picker
            case 'checkbox':
              return _buildCheckboxField(fieldKey, fieldLabel);
            default:
              return _buildTextField(fieldKey, fieldLabel,
                  required: isRequired);
          }
          return Container();
        }).toList(),
      );
    }

    // Fallback pour l'ancien format (si nécessaire)
    return Column(
      children: fieldDefinitions.map<Widget>((fieldDefinition) {
        if (fieldDefinition is! Map<String, dynamic>) return Container();

        final String fieldKey =
            fieldDefinition['name'] ?? fieldDefinition['attribut_label'] ?? '';
        final String fieldLabel = fieldDefinition['attribut_label'] ?? fieldKey;
        final bool isRequired = fieldDefinition['required'] == true;

        switch (fieldDefinition['type_widget']) {
          case 'date':
            return _buildDateField(fieldKey, fieldLabel, isRequired);
          case 'text':
            return _buildTextField(fieldKey, fieldLabel, required: isRequired);
          case 'textarea':
            return _buildTextField(fieldKey, fieldLabel,
                required: isRequired, maxLines: 3);
          case 'number':
            return _buildNumberField(fieldKey, fieldLabel, isRequired);
          case 'select':
            if (fieldDefinition['options'] is List) {
              return _buildSelectField(
                fieldKey,
                fieldLabel,
                isRequired,
                (fieldDefinition['options'] as List)
                    .map<MapEntry<String, String>>((option) {
                  if (option is Map<String, dynamic>) {
                    return MapEntry(
                      option['value']?.toString() ?? '',
                      option['label']?.toString() ??
                          option['value']?.toString() ??
                          '',
                    );
                  }
                  return MapEntry(option.toString(), option.toString());
                }).toList(),
              );
            }
            break;
          case 'checkbox':
            return _buildCheckboxField(fieldKey, fieldLabel);
        }
        return Container();
      }).toList(),
    );
  }

  // Les fonctions _buildGenericField, _buildDateField, _buildTextField, _buildNumberField,
  // _buildSelectField et _buildCheckboxField restent inchangées.

  Widget _buildGenericField(String fieldKey, GenericFieldConfig config) {
    final String fieldLabel = config.attributLabel ?? fieldKey;
    final bool isRequired = config.required ?? false;
    _textControllers[fieldKey] ??= TextEditingController();
    switch (config.typeWidget) {
      case 'date':
        return _buildDateField(fieldKey, fieldLabel, isRequired);
      case 'text':
        return _buildTextField(fieldKey, fieldLabel, required: isRequired);
      case 'textarea':
        return _buildTextField(fieldKey, fieldLabel,
            required: isRequired, maxLines: 3);
      case 'number':
        return _buildNumberField(fieldKey, fieldLabel, isRequired);
      case 'select':
        return _buildSelectField(
          fieldKey,
          fieldLabel,
          isRequired,
          [const MapEntry('placeholder', 'Option (placeholder)')],
        );
      case 'checkbox':
        return _buildCheckboxField(fieldKey, fieldLabel);
      default:
        return _buildTextField(fieldKey, fieldLabel, required: isRequired);
    }
  }

  Widget _buildDateField(String fieldKey, String label, bool required) {
    _textControllers[fieldKey] ??= TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldKey],
            decoration: const InputDecoration(
              hintText: 'Sélectionner une date',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _formValues[fieldKey] ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                setState(() {
                  _textControllers[fieldKey]!.text =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  _formValues[fieldKey] = date;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String fieldKey, String label,
      {bool required = false, int maxLines = 1}) {
    _textControllers[fieldKey] ??= TextEditingController(
      text: _formValues[fieldKey]?.toString() ?? '',
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldKey],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: maxLines,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onChanged: (value) {
              _formValues[fieldKey] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String fieldKey, String label, bool required) {
    _textControllers[fieldKey] ??= TextEditingController(
      text: _formValues[fieldKey]?.toString() ?? '',
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _textControllers[fieldKey],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: required
                ? (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null
                : null,
            onChanged: (value) {
              _formValues[fieldKey] = int.tryParse(value) ?? value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField(
    String fieldKey,
    String label,
    bool required,
    List<MapEntry<String, String>> options,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            required ? '$label *' : label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: _formValues[fieldKey]?.toString(),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option.key,
                child: Text(option.value),
              );
            }).toList(),
            validator: required
                ? (value) => value == null ? 'Ce champ est requis' : null
                : null,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _formValues[fieldKey] = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxField(String fieldKey, String label) {
    bool isChecked = _formValues[fieldKey] == true;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                _formValues[fieldKey] = value;
                isChecked = value ?? false;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
