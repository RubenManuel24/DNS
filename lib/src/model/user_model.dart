class UserModel {
  String nomeCompleto;
  String numeroBI;
  String localResidencia;
  String dataNascimento;
  String genero;
  String estadoCivil;
  String dataEmissao;
  String dataValidade;
  String localEmissao;
  List<String> fotos;

  UserModel({
    required this.nomeCompleto,
    required this.numeroBI,
    required this.localResidencia,
    required this.dataNascimento,
    required this.genero,
    required this.estadoCivil,
    required this.dataEmissao,
    required this.dataValidade,
    required this.localEmissao,
    this.fotos = const [],
  });

  // Construtor para criar objeto a partir de uma string do QR Code
  factory UserModel.fromQR(String qrData) {
    List<String> dados = qrData.split(RegExp(r'\s+'));
    int indexBI = dados.indexWhere((element) => RegExp(r'^\d{9}[A-Z]{2}\d{3}$').hasMatch(element));

    String nomeCompleto = indexBI != -1 ? dados.sublist(0, indexBI).join(' ') : '';
    
    return UserModel(
      nomeCompleto: nomeCompleto,
      numeroBI: dados[indexBI],
      localResidencia: dados[indexBI + 1],
      dataNascimento: dados[indexBI + 2],
      genero: dados[indexBI + 3],
      estadoCivil: dados[indexBI + 4],
      dataEmissao: dados[indexBI + 5],
      dataValidade: dados[indexBI + 6],
      localEmissao: dados[indexBI + 7],
      fotos: [],
    );
  }

  // Método para formatar datas
  static String _formatDate(String date) {
    List<String> partes = date.split('/');
    return "${partes[2]}-${partes[1]}-${partes[0]}";
  }

  // Método para converter objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'nomeCompleto': nomeCompleto,
      'numeroBI': numeroBI,
      'localResidencia': localResidencia,
      'dataNascimento': dataNascimento,
      'genero': genero,
      'estadoCivil': estadoCivil,
      'dataEmissao': dataEmissao,
      'dataValidade': dataValidade,
      'localEmissao': localEmissao,
      'fotos': fotos,
    };
  }
}
