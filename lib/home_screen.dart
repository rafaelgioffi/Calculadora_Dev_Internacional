
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:international_calc/shared/localization/translate_app.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> apiData;
  Home({required this.apiData});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> { 

  final realControlador = TextEditingController();
  final dolarControlador = TextEditingController();
  final euroControlador = TextEditingController();
  final btcControlador = TextEditingController();

  final FocusNode realFocus = FocusNode();
  final FocusNode dolarFocus = FocusNode();
  final FocusNode euroFocus = FocusNode();
  final FocusNode btcFocus = FocusNode();

  double dolar = 0.0;
  double euro = 0.0;
  double btc = 0.0;

  @override
  void initState() {
    super.initState();

    _parseApiData();
    // _dadosMoeda = getData();
    // _loadBannerAd();
    
    realControlador.addListener(_onTextChanged);
    dolarControlador.addListener(_onTextChanged);
    euroControlador.addListener(_onTextChanged);
    btcControlador.addListener(_onTextChanged);

    // --- Listeners para Formatar o Campo Ativo (onFocusChange) ---
    realFocus.addListener(_onRealFocusChange);
    dolarFocus.addListener(_onDolarFocusChange);
    euroFocus.addListener(_onEuroFocusChange);

    // }).catchError((error) {
    //   print('Erro ao carregar dados: $error');
    // });
  }

  void _parseApiData() {
    try {
      final results = widget.apiData["results"];
      final currencies = results["currencies"];
      final usd = currencies["USD"];
      final eur = currencies["EUR"];
      final btcCurrency = currencies["BTC"];

      dolar = (usd["sell"] ?? 0.0).toDouble();
      euro = (eur["sell"] ?? 0.0).toDouble();
      btc = (btcCurrency["sell"] ?? 0.0).toDouble();
    } catch (e) {
      print("Erro ao parsear dados da API no Home: $e");
      // Define valores padrão em caso de falha no parse
      dolar = 1.0;
      euro = 1.0;
      btc = 1.0;
    }
  }

  @override
  void dispose() {    
    // Limpa listeners
    realControlador.removeListener(_onTextChanged);
    dolarControlador.removeListener(_onTextChanged);
    euroControlador.removeListener(_onTextChanged);
    btcControlador.removeListener(_onTextChanged);

    realFocus.removeListener(_onRealFocusChange);
    dolarFocus.removeListener(_onDolarFocusChange);
    euroFocus.removeListener(_onEuroFocusChange);

    //solution deepseek 13/10/25
    realControlador.dispose();
    dolarControlador.dispose();
    euroControlador.dispose();
    btcControlador.dispose();
    //fim deepseek...

    // Limpa focus nodes
    realFocus.dispose();
    dolarFocus.dispose();
    euroFocus.dispose();
    btcFocus.dispose();

    super.dispose();
  }

// Reconstrói o widget para mostrar/esconder o botão 'X'
  void _onTextChanged() {
    setState(() {});
  }

  // Formata o campo de Real quando o usuário sai dele
  void _onRealFocusChange() {
    if (!realFocus.hasFocus) {
      _formatField(realControlador);
    }
  }

  // Formata o campo de Dólar quando o usuário sai dele
  void _onDolarFocusChange() {
    if (!dolarFocus.hasFocus) {
      _formatField(dolarControlador);
    }
  }

  // Formata o campo de Euro quando o usuário sai dele
  void _onEuroFocusChange() {
    if (!euroFocus.hasFocus) {
      _formatField(euroControlador);
    }
  }

  // Função genérica para formatar o campo
  void _formatField(TextEditingController controller) {
    if (controller.text.isEmpty) return;
    final formatador = _getCurrencyFormat(context);
    double value = _parseInput(controller.text);

    // Usamos setState para garantir que o listener _onTextChanged
    // também seja notificado caso o texto mude.
    setState(() {
      controller.text = formatador.format(value);
    });
  }  
  
// Função helper para formatar saida...
  NumberFormat _getCurrencyFormat(BuildContext context) {
    final deviceLocale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.currency(
        locale: deviceLocale, symbol: '', decimalDigits: 2);
  }

  void _clearFields() {
    realControlador.clear();
    dolarControlador.clear();
    euroControlador.clear();
    btcControlador.clear();
  }

  // Helper para ler um número (ex: "1.234,56" ou "1234.56")
  double _parseInput(String text) {
    final formatador = _getCurrencyFormat(context);
    // Remove separadores de milhar (ex: 10.000 -> 10000)
    String cleanText = text.replaceAll(formatador.symbols.GROUP_SEP, '');
    // Troca separador decimal do locale por '.' (ex: 10,50 -> 10.50)
    cleanText = cleanText.replaceAll(formatador.symbols.DECIMAL_SEP, '.');

    try {
      return double.parse(cleanText);
    } catch (e) {
      return 0.0;
    }
  }
  
  // --- Funções de Conversão ---
  void _realTroca(String text) {
    // if (text.isEmpty) {
    if (!realFocus.hasFocus) return;

    if (text.isEmpty) {
      _clearFields();
      return;
    }

    final formatador = _getCurrencyFormat(context);
    double real = _parseInput(text);

    dolarControlador.text = formatador.format(real / dolar);
    euroControlador.text = formatador.format(real / euro);
    btcControlador.text = (real / btc).toStringAsFixed(10);    
  }

  void _dolarTroca(String text) {
    if (!dolarFocus.hasFocus) return;

    if (text.isEmpty) {
      _clearFields();
      return;
    }

    final formatador = _getCurrencyFormat(context);
    double dolarValue = _parseInput(text);
    
    realControlador.text = formatador.format(dolarValue * this.dolar);
    euroControlador.text = formatador.format((dolarValue * this.dolar) / euro);
    btcControlador.text = ((dolar * this.dolar) / btc).toStringAsFixed(10);
  }

  void _euroTroca(String text) {
    if (!euroFocus.hasFocus) return;
    if (text.isEmpty) {
      _clearFields();
      return;
    }

    final formatador = _getCurrencyFormat(context);
    double euroValue = _parseInput(text);
    
    realControlador.text = formatador.format(euroValue * this.euro);
    dolarControlador.text = formatador.format((euroValue * this.euro) / dolar);
    btcControlador.text = ((euro * this.euro) / btc).toStringAsFixed(10);
  }

  void _btcTroca(String text) {
    if (!btcFocus.hasFocus) return;
    if (text.isEmpty) {      
      _clearFields();
      return;
    }
    
    String parseableText = text.replaceAll(',', '.');
    double btcValue;
    try {
      btcValue = double.parse(parseableText);
    } catch (e) {
      btcValue = 0.0;
    }

    final formatador = _getCurrencyFormat(context);
    realControlador.text = formatador.format(btcValue * this.btc);
    dolarControlador.text = formatador.format((btcValue * this.btc) / dolar);
    euroControlador.text = formatador.format((btcValue * this.btc) / euro);
  }

  @override
  Widget build(BuildContext context) {    
                // return Stack(
                return Column(
                  children: [
                    Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),                      
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 100.0,
                              // color: Colors.lightGreen,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Divider(),
                            criaTextsFields(
                              TranslateApp(context).text('real'),
                              "R\$",
                              realControlador,
                              realFocus,
                              _realTroca,
                            ),
                            Divider(),
                            criaTextsFields(
                              TranslateApp(context).text('dolar'),
                              // 'Dólar',
                              "US\$",
                              dolarControlador,
                              dolarFocus,
                              _dolarTroca,
                            ),
                            Divider(),
                            criaTextsFields(
                              TranslateApp(context).text('euro'),
                              // 'Euro',
                              "€",
                              euroControlador,
                              euroFocus,
                              _euroTroca,
                            ),
                            Divider(),
                            criaTextsFields(
                              "Bitcoin",
                              "BTC",
                              btcControlador,
                              btcFocus,
                              _btcTroca,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // _buildBannerAdWidget(),
                  ],
                );
              }
  //         }
  //       },
  //     );    
  // }


Widget criaTextsFields(
    String texto,
    String prefix,
    TextEditingController c,
    FocusNode focus,
    Function(String) f,
  ) {
    return TextField(
      controller: c,
      focusNode: focus,
      decoration: InputDecoration(
        labelText: texto,
        // labelStyle: TextStyle(color: Colors.green),
        labelStyle: GoogleFonts.lato(color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withAlpha(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        prefixText: prefix,
        prefixStyle: GoogleFonts.lato(
            // color: Colors.green,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 25.0),
        // ADICIONA O BOTÃO DE LIMPAR (X)
        suffixIcon: c.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.green[400]),
                onPressed: _clearFields,
              )
            : null, // Não mostra nada se o campo estiver vazio
      ),
      style: GoogleFonts.lato(
          // color: Colors.green,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 25.0),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: f,
    );
  }
}
