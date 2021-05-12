# Brainfuck для Радио-86РК

![title](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/master/pictures/bfon86rk.png)

Наверняка те радиолюбители, что жили в СССР, слышали (а кто-то даже собирал) о домашнем 8-битном компьютере [Радио-86РК](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B4%D0%B8%D0%BE-86%D0%A0%D0%9A). Компьютер был довольно прост в изготовлении и потому получил большую популярность.  
Работает он на процессоре КР580ВМ80А (клон Intel 8080A), имеет Ч/Б видеосистему на КР580ВГ75 (клон Intel 8275), 32Кб ОЗУ и способен загружать/выгружать данные на аудиоустройство. Поэтому ничего не мешает выполнять на нем Brainfuck.

## Версии исполнителя
Исполнитель существует в двух версиях: "К" и "П".  
 * Версия "К" (Кассета) после запуска, с помощью загрузчика в ROM-BIOS, загружает Brainfuck код в память, а затем выполняет его.
 * Версия "П" (Память) предполагает, что пользователь каким-либо образом уже расположил Brainfuck код в памяти, начиная с адреса **0x019A**, и сразу выполняет его.

## Адресные данные
Для Brainfuck программы выделяется 25000 8-битных ячеек (стандартные 30000 невозможно выделить ввиду всего 32Кб ОЗУ)    
	Адреса: **0x1458-0x75FF**  
Для Brainfuck кода выделяется: в "К" версии - 4655 байт, в "П" версии - 4798 байт  
	Адреса:	**0x0229-0x1457** или **0x019A-0x1457**  
Сам исполнитель занимает: в "К" версии - 553 байт, в "П" версии - 410 байт  
	Адреса:	**0x0000-0x0228** или **0x0000-0x0199**

## Особенности
* Исполнитель способен сообщать о базовых ошибках, произошедших при загрузке или выполнении Brainfuck кода.
 Программа остановится если: при загрузке кода с кассеты не совпали контрольные суммы; файл с кассеты слишком большой; указатель на ячейку вышел за пределы отведенной памяти; в коде нет скобки открывающей/закрывающей цикл.

* Любой Brainfuck код должен заканчиваться байтом **0x00**, обозначающим конец кода.

* Если Brainfuck код запрашивает ввод символа, на новой строке появится знак ">". После нажатия клавиши символ выведется на экран и будет передан коду. 

## Работа на клонах
Существует много клонов и частично совместимых с Радио-86РК компьютеров.
Работа проверена на следующих клонах (с помощью эмулятора):
* Спектр-001
* Апогей БК-01

Не работоспособен на:
* Микроша (другая система подсчета контр. суммы, другие адреса подпрограмм загрузчика и возврата в монитор)
* Микро-80 (нет подсчета контр. суммы, другие адреса подпрограмм загрузчика и возврата в монитор)
* Партнер 01.01 (другие адреса подпрограмм загрузчика и возврата в монитор)
* ЮТ-88 (другая система подсчета контр. суммы, другие адреса подпрограмм загрузчика и возврата в монитор)

Возможно для этих компьютеров будут созданы отдельные ветки с версиями для них (мне пока не известны правильные адреса).

## FAQ

* После запуска, вместо, например "Hello World!", на дисплее показывается странный "HЕЛЛО WОРЛД!".

   ![letters](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/master/pictures/hello.png)
	  
   Данная проблема связана с устройством видеоконтроллера. Его знакогенератор рассчитан на 128 символов, поэтому для умещения руссих букв из него были убраны маленькие английские и заменены их фонетическими аналогами в русском языке.  
   Исправить данное положение можно, переписав программу под вывод текста заглавными английскими буквами, например "HELLO WORLD!"
	  
* Текст при печати "разбросан" по дисплею

   ![nolf](https://raw.githubusercontent.com/Bs0Dd/brainfuck-86rk/master/pictures/nolf.png)
	  
   Скорее всего Brainfuck код для перехода на следующую строку печатает только символ LF (**0x0A**), поскольку в современных системах он выполняет и переход на новую строку и перенос курсора в ее начало. В данном компьютере такого нет, поэтому для переноса курсора в начало необходимо напечатать символ CR (**0x0D**).  
   Для исправления этой проблемы достаточно в коде, после каждой команды, выводящей LF, добавить строчку `+++.---`. Тогда после LF сразу будет выводиться CR и проблемы с переносом не будет.
   
## Changelog
* Версия 1.4
   * Уменьшен размер "К" версии
   * Исправлен баг в системе остановки при ошибке
   * Исправлен критический баг, ломающий выполнение команд при адресе текущей ячейки от **0x2B00**.
* Версия 1.3
   * Первая публичная версия.
   * Исправлен критический баг, при некоторых обстоятельствах приводящий к зависанию программы.
* Версия 1.2
   * Исполнитель больше не хранит адрес конца Brainfuck кода, а останавливается по достижении символа **0x00**. Это позволило упростить программу и еще немного уменьшить размер.
   * Разделение на версии "К" и "П".
* Версия 1.1
   * Оптимизирован и уменьшен код.
* Версия 1.0
   * Первая версия, непубличная.
