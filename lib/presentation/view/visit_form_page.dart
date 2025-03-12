import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

class VisitFormPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final BaseVisit? visit; // Optional: existing visit for edit mode

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

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.visit != null;

    // Pré-remplir le formulaire en mode édition
    if (_isEditMode && widget.visit != null) {
      _initFormValuesFromVisit(widget.visit!);
    }
  }

  void _initFormValuesFromVisit(BaseVisit visit) {
    // Initialiser les valeurs de base
    _formValues['visit_date_min'] = visit.visitDateMin;
    _textControllers['visit_date_min'] = TextEditingController(
      text: visit.visitDateMin != null
          ? DateTime.parse(visit.visitDateMin).toIso8601String().split('T')[0]
          : '',
    );

    _formValues['comments'] = visit.comments;
    _textControllers['comments'] =
        TextEditingController(text: visit.comments ?? '');

    // Ajouter d'autres champs si nécessaire basés sur la configuration
  }

  @override
  void dispose() {
    // Libérer les controllers
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les champs spécifiques du formulaire
    final Map<String, dynamic> specificFields =
        widget.visitConfig.specific ?? {};
    // Récupérer les champs génériques du formulaire
    final Map<String, GenericFieldConfig> genericFields =
        widget.visitConfig.generic ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? 'Modifier la visite'
            : widget.visitConfig.label ?? 'Nouvelle visite'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(specificFields, genericFields),
    );
  }

  Widget _buildForm(Map<String, dynamic> specificFields,
      Map<String, GenericFieldConfig> genericFields) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations de base
                    Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
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

                            // Champ de date
                            _buildDateField(
                                'visit_date_min', 'Date de la visite', true),

                            // Champ de commentaire
                            _buildTextField('comments', 'Commentaires',
                                maxLines: 3),
                          ],
                        ),
                      ),
                    ),

                    // Champs spécifiques du formulaire
                    if (specificFields.isNotEmpty)
                      ..._buildSpecificFormSections(specificFields),

                    // Champs génériques du formulaire
                    if (genericFields.isNotEmpty)
                      Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Champs complémentaires',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...genericFields.entries.map((entry) {
                                final fieldKey = entry.key;
                                final fieldConfig = entry.value;
                                return _buildGenericField(
                                    fieldKey, fieldConfig);
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Boutons d'action
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
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
                    child: Text(_isEditMode ? 'Mettre à jour' : 'Enregistrer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSpecificFormSections(Map<String, dynamic> specificFields) {
    final List<Widget> sections = [];

    // Traiter chaque section du formulaire spécifique
    specificFields.forEach((sectionKey, sectionData) {
      if (sectionData is Map<String, dynamic>) {
        // Créer une carte pour chaque section
        sections.add(
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de la section
                  Text(
                    sectionData['title'] ?? sectionKey,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Récupérer les champs de la section
                  if (sectionData['fields'] is Map<String, dynamic>)
                    ...(_buildSpecificFields(
                        sectionData['fields'] as Map<String, dynamic>)),
                ],
              ),
            ),
          ),
        );
      }
    });

    return sections;
  }

  List<Widget> _buildSpecificFields(Map<String, dynamic> fields) {
    final List<Widget> fieldWidgets = [];

    fields.forEach((fieldKey, fieldData) {
      if (fieldData is Map<String, dynamic>) {
        final String fieldType = fieldData['type'] ?? 'text';
        final String fieldLabel = fieldData['label'] ?? fieldKey;
        final bool isRequired = fieldData['required'] == true;

        switch (fieldType) {
          case 'date':
            fieldWidgets.add(_buildDateField(fieldKey, fieldLabel, isRequired));
            break;
          case 'text':
            fieldWidgets.add(
                _buildTextField(fieldKey, fieldLabel, required: isRequired));
            break;
          case 'textarea':
            fieldWidgets.add(_buildTextField(fieldKey, fieldLabel,
                required: isRequired, maxLines: 3));
            break;
          case 'number':
            fieldWidgets
                .add(_buildNumberField(fieldKey, fieldLabel, isRequired));
            break;
          case 'select':
            if (fieldData['options'] is List) {
              fieldWidgets.add(_buildSelectField(
                fieldKey,
                fieldLabel,
                isRequired,
                (fieldData['options'] as List)
                    .map<MapEntry<String, String>>((option) {
                  if (option is Map<String, dynamic>) {
                    return MapEntry(
                        option['value']?.toString() ?? '',
                        option['label']?.toString() ??
                            option['value']?.toString() ??
                            '');
                  }
                  return MapEntry(option.toString(), option.toString());
                }).toList(),
              ));
            }
            break;
          case 'checkbox':
            fieldWidgets.add(_buildCheckboxField(fieldKey, fieldLabel));
            break;
          default:
            fieldWidgets.add(
                _buildTextField(fieldKey, fieldLabel, required: isRequired));
        }
      }
    });

    return fieldWidgets;
  }

  Widget _buildGenericField(String fieldKey, GenericFieldConfig config) {
    final String fieldLabel = config.attributLabel ?? fieldKey;
    final bool isRequired = config.required ?? false;

    // Initialiser le controller si nécessaire
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
      case 'nomenclature':
        // Pour les nomenclatures, il faudrait idéalement récupérer les valeurs depuis la base
        return _buildSelectField(
          fieldKey,
          fieldLabel,
          isRequired,
          [
            const MapEntry(
                'placeholder', 'Option de nomenclature (placeholder)')
          ],
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
    _textControllers[fieldKey] ??=
        TextEditingController(text: _formValues[fieldKey]?.toString() ?? '');

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
    _textControllers[fieldKey] ??=
        TextEditingController(text: _formValues[fieldKey]?.toString() ?? '');

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

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implémenter la sauvegarde de la visite
        // Soit mise à jour d'une visite existante, soit création d'une nouvelle
        await Future.delayed(
            const Duration(seconds: 2)); // Simuler une opération asynchrone

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode
                  ? 'Visite mise à jour avec succès (Simulation)'
                  : 'Visite créée avec succès (Simulation)'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la sauvegarde: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
