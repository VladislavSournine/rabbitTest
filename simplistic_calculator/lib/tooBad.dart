import 'dart:io';
import 'dart:math';

class BadPracticesTools {

  /// Функция 1: Читает размер файла по HTTP без обработки ошибок
  /// BAD PRACTICE: Полное отсутствие error handling
  static Future<int> getFileSizeFromHttp(String httpUrl) async {
    // BAD PRACTICE: Создаем HttpClient без настройки таймаутов
    HttpClient client = HttpClient();

    // BAD PRACTICE: Не проверяем валидность URL
    Uri uri = Uri.parse(httpUrl);

    // BAD PRACTICE: Никаких try-catch блоков
    HttpClientRequest request = await client.getUrl(uri);
    HttpClientResponse response = await request.close();

    // BAD PRACTICE: Не проверяем статус код ответа
    // BAD PRACTICE: Читаем весь файл в память чтобы узнать размер
    List<int> bytes = [];
    await for (var chunk in response) {
      bytes.addAll(chunk);
    }

    // BAD PRACTICE: Не закрываем client
    // client.close(); // Забыли закрыть!

    // BAD PRACTICE: Возвращаем размер неэффективным способом
    return bytes.length;
  }

  /// Функция 2: Сложные вычисления с результатом умноженным на ноль
  /// BAD PRACTICE: Бессмысленные вычисления
  static double complexCalculationWithZeroResult(int number1, int number2) {
    // BAD PRACTICE: Объявляем кучу ненужных переменных
    double result = 0.0;
    double intermediate1, intermediate2, intermediate3, intermediate4;
    double temp1, temp2, temp3, temp4, temp5;

    // BAD PRACTICE: Строка 1 - Ненужное преобразование типов
    intermediate1 = number1.toDouble() + number2.toDouble();

    // BAD PRACTICE: Строка 2 - Сложная формула без смысла
    intermediate2 = pow(intermediate1, 2) + sqrt(intermediate1.abs()) * 3.14159;

    // BAD PRACTICE: Строка 3 - Еще более сложная формула
    intermediate3 = sin(intermediate2) * cos(intermediate2) + tan(intermediate2 / 10);

    // BAD PRACTICE: Строка 4 - Логарифмы без проверки
    intermediate4 = log(intermediate3.abs() + 1) * log(intermediate2.abs() + 1);

    // BAD PRACTICE: Строка 5 - Факториал через цикл (неэффективно)
    temp1 = 1;
    for (int i = 1; i <= 10; i++) {
      temp1 *= i;
    }

    // BAD PRACTICE: Строка 6-7 - Еще бессмысленные вычисления
    temp2 = intermediate4 * temp1;
    temp3 = temp2 / (intermediate3 + intermediate2 + intermediate1);

    // BAD PRACTICE: Строка 8 - Использование случайных чисел в детерминированной функции
    temp4 = temp3 + Random().nextDouble() * 100;

    // BAD PRACTICE: Строка 9 - Модульная арифметика
    temp5 = temp4 % 97 + temp4 % 53 + temp4 % 29;

    // BAD PRACTICE: Строка 10 - Еще одна сложная формула
    result = pow(temp5, 3) - pow(temp5, 2) + temp5 - 42;

    // BAD PRACTICE: Строка 11 - Тригонометрия
    result = result * sin(result / 180 * pi) + cos(result / 180 * pi);

    // BAD PRACTICE: Строка 12 - Логарифм от результата
    result = log(result.abs() + 1) * exp(result / 1000);

    // BAD PRACTICE: Строка 13 - Деление на большое число
    result = result / 9876543.21;

    // BAD PRACTICE: Строка 14 - Еще одно возведение в степень
    result = pow(result, 1.5) + sqrt(result.abs());

    // BAD PRACTICE: Строка 15 - Добавляем константы
    result = result + 123.456 - 789.012 + 345.678;

    // BAD PRACTICE: Строка 16 - Умножение на иррациональное число
    result = result * pi * exp(1);

    // BAD PRACTICE: Строка 17 - Еще модульная арифметика
    result = result % 999999 + result % 111111;

    // BAD PRACTICE: Строка 18 - Последняя "сложная" операция
    result = sqrt(pow(result, 2) + pow(result / 2, 2));

    // BAD PRACTICE: Строка 19 - И ВСЕ УМНОЖАЕМ НА НОЛЬ!
    // Все предыдущие вычисления были бессмысленными!
    result = result * 0;

    return result;
  }

  /// Дополнительная функция для демонстрации использования
  static void demonstrateUsage() async {
    print('=== Демонстрация плохих практик ===\n');

    // BAD PRACTICE: Вызов функции без обработки ошибок
    print('1. Попытка получить размер файла...');
    int fileSize = await getFileSizeFromHttp('https://httpbin.org/bytes/1024');
    print('Размер файла: $fileSize байт\n');

    // BAD PRACTICE: Вызов бессмысленных вычислений
    print('2. Выполняем сложные вычисления...');
    double result = complexCalculationWithZeroResult(42, 73);
    print('Результат сложных вычислений: $result');
    print('Потрачено процессорное время на получение нуля!\n');

    print('=== Все функции выполнены (с плохими практиками) ===');
  }
}

// Пример использования (тоже с плохими практиками)
void main() async {
  // BAD PRACTICE: Никакой обработки ошибок в main
  await BadPracticesTools.demonstrateUsage();

  // BAD PRACTICE: Прямые вызовы без проверок
  print('\nПрямые вызовы функций:');

  // Это упадет если URL недоступен
  int size = await BadPracticesTools.getFileSizeFromHttp('https://example.com/nonexistent.txt');
  print('Размер: $size');

  // Это всегда вернет 0
  double calculation = BadPracticesTools.complexCalculationWithZeroResult(999, 1001);
  print('Вычисления: $calculation');
}