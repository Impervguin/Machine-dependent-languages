### Задание

Написать резидентную программу под DOS, которая будет каждую секунду менять скорость автоповтора ввода символов в циклическом режиме, от самой медленной до самой быстрой.

Мой вариант вызова предшествующего прерывание:
Командой дальнего безусловного перехода JMP в конце обработчика прерывания, сохранив адрес перехода в переменной.