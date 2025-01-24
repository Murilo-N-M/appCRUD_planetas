// Suggested code may be subject to a license. Learn more: ~LicenseLog:3931712399.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3338271083.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3209861887.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1840171048.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3590989321.
import 'package:flutter/material.dart';
import 'package:CRUDplanetas/controles/controle_planeta.dart';
import 'package:CRUDplanetas/models/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final Planeta planeta;
  final bool isIncluir;
  final Function() onSubmit;
  
  const TelaPlaneta({
    super.key,
    required this.onSubmit,
    required this.planeta,
    required this.isIncluir,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

//Iniciação da classe e funções
class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _massaController = TextEditingController();
  final TextEditingController _distanciaSolarController =
      TextEditingController();
  final TextEditingController _funFactController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _apelidoController.text = _planeta.apelido ?? '';
    _tamanhoController.text = _planeta.tamanho.toString();
    _massaController.text = _planeta.massa.toString();
    _distanciaSolarController.text = _planeta.distanciaSolar.toString();
    _funFactController.text = _planeta.funFact ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _apelidoController.dispose();
    _tamanhoController.dispose();
    _massaController.dispose();
    _distanciaSolarController.dispose();
    _funFactController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Dados do planeta ${_planeta.nome} foram ${widget.isIncluir ? 'salvos' : 'alterados'} com sucesso!'),
        ),
      );
      Navigator.of(context).pop();
      widget.onSubmit();
    }
  }

//Build principal do Cadastro de planetas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //TextFormField para NOME
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome do planeta é obrigatório';
                    } else if (value.length < 3) {
                      return 'O nome deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                //SizedBox para distanciar cada TextFormField/deixar bonito
                const SizedBox(height: 15.0),
                //TextFormField para APELIDO
                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(
                    labelText: 'Apelido (Opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 3) {
                      return 'O apelido deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.apelido = value;
                  },
                ),
                const SizedBox(height: 15.0),
                //TextFormField para TAMANHO
                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O tamanho do planeta é obrigatório';
                    } else if (!RegExp(r'^[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$')
                        .hasMatch(value)) {
                      return 'Apenas números ou anotações científicas são aceitos';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                const SizedBox(height: 15.0),
                //TextFormField para MASSA
                TextFormField(
                  controller: _massaController,
                  decoration: InputDecoration(
                    labelText: 'Massa (em kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A massa do planeta é obrigatória';
                    } else if (!RegExp(r'^[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$')
                        .hasMatch(value)) {
                      return 'Apenas números ou anotações científicas são aceitos';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _planeta.massa = double.parse(value!);
                  },
                ),
                const SizedBox(height: 15.0),
                //TextFormField para DISTANCIA SOLAR
                TextFormField(
                  controller: _distanciaSolarController,
                  decoration: InputDecoration(
                    labelText: 'Distancia do Sol (em km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A distancia do Sol é obrigatório';
                    } else if (!RegExp(r'^[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$')
                        .hasMatch(value)) {
                      return 'Apenas números ou anotações científicas são aceitos';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distanciaSolar = double.parse(value!);
                  },
                ),
                const SizedBox(height: 15.0),
                //TextFormField para FUNFACT
                TextFormField(
                  controller: _funFactController,
                  decoration: InputDecoration(
                    labelText: 'Curiosidade (Opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length < 15) {
                      return 'O texto deve ter pelo menos 15 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.funFact = (value!);
                  },
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                  ),
                  onPressed: _submitForm,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
