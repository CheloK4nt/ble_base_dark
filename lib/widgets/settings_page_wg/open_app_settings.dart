import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenAppSettings extends StatefulWidget {
  const OpenAppSettings({super.key});

  @override
  State<OpenAppSettings> createState() => _OpenAppSettingsState();
}

class _OpenAppSettingsState extends State<OpenAppSettings> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Ir a ajustes"),
      subtitle: Text("Configuración de la app. Puedes configurar los permisos, entre otras opciones."),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () => openAppSettings(),
    );
  }
}