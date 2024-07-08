class ValidarCpf {
  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length != 11) {
      return false;
    }

    if (cpf == '00000000000' ||
        cpf == '11111111111' ||
        cpf == '22222222222' ||
        cpf == '33333333333' ||
        cpf == '44444444444' ||
        cpf == '55555555555' ||
        cpf == '66666666666' ||
        cpf == '77777777777' ||
        cpf == '88888888888' ||
        cpf == '99999999999') {
      return false;
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int primeiroDigito = (soma * 10) % 11;
    if (primeiroDigito == 10) {
      primeiroDigito = 0;
    }

    if (int.parse(cpf[9]) != primeiroDigito) {
      return false;
    }

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int segundoDigito = (soma * 10) % 11;
    if (segundoDigito == 10) {
      segundoDigito = 0;
    }

    if (int.parse(cpf[10]) != segundoDigito) {
      return false;
    }

    return true;
  }
}