import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:montesBelos/core/utils/builder/correcao_de_texto.dart';
import 'package:montesBelos/core/utils/constants/configuracao.dart';
import 'package:montesBelos/core/utils/constants/constants.dart';
import 'package:montesBelos/core/utils/constants/strings.dart';
import 'package:montesBelos/features/data/models/get_agencias_request.dart';
import 'package:montesBelos/features/domain/entities/agencia.dart';
import 'package:montesBelos/features/presenter/store/get_origem_store.dart';
import 'package:montesBelos/features/presenter/store/purchase_request_store.dart';

class OrigemPage extends StatefulWidget {
  @override
  _BuscaPageState createState() => _BuscaPageState();
}

class _BuscaPageState extends State<OrigemPage> {
  final TextEditingController buscaController = TextEditingController();
  final FocusNode buscaFocusNode = FocusNode(); // FocusNode criado

  final OrigemStore getOrigemStore = Modular.get();
  List<Agencia> agenciasDeOrigem = [];
  var agenciaSelecionada = null;

  @override
  void dispose() {
    buscaController.dispose();
    buscaFocusNode.dispose(); // Liberando o FocusNode ao destruir o widget
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Adicionando o foco automaticamente quando a tela é carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(buscaFocusNode);
    });

    getOrigemStore.observer(
      onState: (List<Agencia> agencias) {
        setState(() {
          agenciasDeOrigem = [];
          this.agenciasDeOrigem = agencias;
        });
      },
    );
  }

  void buscarAgencias(String value) {
    if (value.length >= 3) {
      getOrigemStore.getAgenciasDeOrigem(GetAgenciasRequest(
        valorInseridoPeloUsuario: value,
      ));
    } else {
      setState(() {
        agenciasDeOrigem = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Configuracao().COR_PRINCIPAL,
      ),
      body: buildComponentesDaTela(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildComponentesDaTela() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: buscaController,
            focusNode: buscaFocusNode, // Associando o FocusNode ao campo
            onChanged: (value) {
              buscarAgencias(value);
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: Constants.FONT_DO_APP,
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.circle_outlined,
                  color: Color.fromARGB(50, 0, 0, 0)),
              errorStyle: TextStyle(
                  color: Color.fromARGB(50, 0, 0, 0),
                  fontSize: 12,
                  fontFamily: Constants.FONT_DO_APP,
                  fontWeight: FontWeight.w300),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(50, 0, 0, 0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: Color.fromARGB(255, 0, 51, 102),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 23, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(50, 0, 0, 0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(50, 0, 0, 0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: busca_page__text_hint_partindo_de,
              hintStyle: const TextStyle(
                  color: Color.fromARGB(120, 0, 0, 0),
                  fontSize: 16,
                  fontFamily: Constants.FONT_DO_APP,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: agenciasDeOrigem.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(CorrecaoDeTexto().getNomeDosTrechosCorrigidos(
                          agenciasDeOrigem[index].name!) +
                      ' - ' +
                      agenciasDeOrigem[index].uf!),
                  onTap: () {
                    Agencia agenciaSelecionada = agenciasDeOrigem[index];

                    PurchaseRequestStorage.salvarOrigemSelecionada(
                        agenciaSelecionada);

                    Modular.to.pushNamed('/');
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
