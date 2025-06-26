import 'dart:io'; // Requerido para operaciones de archivo como File.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Requerido para cargar assets como el PDF.
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart'; // Importa path_provider


void main() {
  runApp(const EncuentraTuAulaApp());
}

class EncuentraTuAulaApp extends StatelessWidget {
  const EncuentraTuAulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EncuentraTuAula',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Encuentra Tu Aula'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String _pdfAssetPath = 'assets/PLANOS_INGENIERIA_CIENCIAS.pdf';
  String? _localPdfPath; // Almacena la ruta local del PDF después de copiarlo desde assets.

  final FocusNode _searchFocusNode = FocusNode(); // Controla el foco del campo de texto de búsqueda.

  // Prepara el PDF copiándolo desde los assets a un directorio local al iniciar el widget.
  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    // Copia el archivo PDF desde los assets a un directorio temporal para que PDFView pueda cargarlo.
    try {
      final byteData = await rootBundle.load(_pdfAssetPath);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/PLANOS_INGENIERIA_CIENCIAS.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      setState(() {
        _localPdfPath = file.path;
      });
    } catch (e) {
      print("Error al preparar el PDF: $e");
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Libera los recursos del FocusNode cuando el widget se destruye.
    super.dispose();
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el sheet sea más alto y maneje el teclado
      backgroundColor: Colors.transparent, // Fondo transparente para permitir esquinas redondeadas en el Container interno.
      builder: (BuildContext bc) {
        // Solicita el foco para el campo de texto después de que el BottomSheet se haya renderizado.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(bc).requestFocus(_searchFocusNode);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Asegura que el TextField esté visible sobre el teclado.
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white, // Color de fondo del BottomSheet
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // El BottomSheet solo ocupará el alto necesario para su contenido.
              children: <Widget>[
                TextField(
                  focusNode: _searchFocusNode,
                  autofocus: true, // Enfoca automáticamente el campo y muestra el teclado.
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí para buscar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Theme.of(bc).primaryColor),
                    ),
                  ),
                  onSubmitted: (value) {
                    // Lógica a ejecutar cuando el usuario envía el texto de búsqueda.
                    print('Buscando: $value');
                    Navigator.pop(bc); // Cierra el BottomSheet.
                  },
                ),
                const SizedBox(height: 10), // Espacio adicional debajo del TextField.
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Barra de aplicación superior.
        backgroundColor: Colors.transparent, // Transparente para mostrar el fondo del Stack.
        elevation: 0, // Sin sombra, para una integración más fluida con el fondo.
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white), // Color del texto del título para contraste con el fondo.
        ),
      ),
      extendBodyBehindAppBar: true, // El cuerpo del Scaffold se extiende detrás del AppBar.
      body: Stack( // Permite superponer widgets, como el GIF de fondo y el contenido principal.
        children: <Widget>[
          // Capa de fondo: GIF animado.
          Positioned.fill( // El GIF se expandirá para llenar todo el espacio del Stack.
            child: Image.asset(
              'assets/anim_background.gif', // Reemplaza con el nombre de tu GIF
              fit: BoxFit.cover, // Asegura que el GIF cubra todo el área, recortando si es necesario.
            ),
          ),
          // Capa de contenido principal: PDF y barra de búsqueda.
          Column(
            children: <Widget>[
              // Espacio reservado para el AppBar y la barra de estado del sistema.
              SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
              Expanded(
                child: _localPdfPath == null
                    ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.white70)) // Indicador de carga mientras se prepara el PDF.
                    : PDFView(
                        filePath: _localPdfPath,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: false,
                        pageFling: true,
                        pageSnap: true,
                        defaultPage: 0,
                        fitPolicy: FitPolicy.BOTH,
                        preventLinkNavigation: false,
                        onRender: (_pages) {
                          print("PDF renderizado con $_pages páginas!");
                        },
                        onError: (error) {
                          print("Error en PDFView: ${error.toString()}");
                        },
                        onPageError: (page, error) {
                          print('$page: ${error.toString()}');
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _showSearchBottomSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Hacemos el fondo completamente transparente.
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2), // Sombra un poco más oscura para dar profundidad.
                          spreadRadius: 1,
                          blurRadius: 8, // Blur más pronunciado para la sombra.
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.search, color: Color.fromARGB(255, 255, 255, 255)),
                        SizedBox(width: 12), // Icono de búsqueda con un color negro más sólido.
                        Text(
                          'Buscar sala, profesor, departamento...',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w500), // Texto más oscuro y ligeramente más grueso.
                        ), // Texto de la barra de búsqueda con un color negro más sólido.
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // El backgroundColor del Scaffold ya no es necesario aquí, ya que el Stack gestiona el fondo con el GIF.
    );
  }
}
