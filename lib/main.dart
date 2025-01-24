import 'package:flutter/material.dart';
import 'package:CRUDplanetas/controles/controle_planeta.dart';
import 'package:CRUDplanetas/models/planeta.dart';
import 'package:CRUDplanetas/telas/tela_planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 183, 255)),
        useMaterial3: true,
      ),
      home: const MeuAppPlanetas(
        title: 'App - Planetas',
      ),
    );
  }
}

class MeuAppPlanetas extends StatefulWidget {
  const MeuAppPlanetas({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MeuAppPlanetas> createState() => _MeuAppPlanetasState();
}

class _MeuAppPlanetasState extends State<MeuAppPlanetas> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _atualizarListaPlanetas();
  }

//Atulualiza a pagina para mostrar a lista de planetas
  Future<void> _atualizarListaPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

//abre a tela de cadastro de planetas
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onSubmit: () {
            _atualizarListaPlanetas();
          },
        ),
      ),
    );
  }

//abre a tela de cadastro de planetas mas para editar-lo utilizando seu ID unico
  void _atualizarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onSubmit: () {
            _atualizarListaPlanetas();
          },
        ),
      ),
    );
  }

//exclui um planeta utilizando seu ID unico
  void _excluirPlaneta(int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este planeta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                await _controlePlaneta.excluirPlaneta(id);
                _atualizarListaPlanetas();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Planeta excluido com sucesso!')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      //Utilizando SingleChieldScrollView para poder ver todos os planetas
      //caso precise mover a tela
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _planetas.length,
          itemBuilder: (context, index) {
            final planeta = _planetas[index];
            //Colocar um Container para fazer a borda envolta de cada planeta
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 245, 255),
                  border: Border.all(
                      color: const Color.fromARGB(255, 134, 182, 245),
                      width: 3.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //Checa se o planeta possui apelido, caso possuir mostre ele
                //junto ao nome, caso não mostrar somente o nome
                child: ListTile(
                  title: planeta.apelido!.isNotEmpty
                      ? Text('${planeta.nome}, ${planeta.apelido}')
                      : Text(planeta.nome),
                  //Subtitulo em coluna para mostrar todas caracteristicas
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tamanho: ${planeta.tamanho.toString()}'),
                      Text('Massa: ${planeta.massa.toString()}'),
                      Text(
                          'Distancia solar: ${planeta.distanciaSolar.toString()}'),
                      if (planeta.funFact!.isNotEmpty)
                        Text('Curiosidade: ${planeta.funFact}'),
                    ],
                  ),
                  //Uso do trailing e Row para colocar os botões de 'edit' e
                  //'delete' em frente de cada planeta da lista
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _atualizarPlaneta(context, planeta),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _excluirPlaneta(planeta.id!),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      //botao para ir para a pagina de criação/anotação/inclusão de planetas
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 183, 255),
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
        onPressed: () => _incluirPlaneta(context),
                  child: const Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }
}
