*Лим Владислав БПИ225*
*Задания семинара 2*


***Объяснение связей***

**Задача 1**

**Условие задачи**

*Нарисуйте E/R диаграмму для библиотечной системы на основе следующих требований:*

 * *В библиотеки хранятся экземпляры книг. Каждая копия (экземпляр) имеет свой уникальный номер копии, положение на полке и может быть однозначно идентифицирована с помощью номера копии вместе с ISBN.*

 * *Каждая книга имеет уникальный номер ISBN, год, название, автора и количество страниц.* 

 * *Книги издаются издательствами. У издателя есть имя и адрес.*

 * *В библиотечной системе книгам присвоена одна категория или несколько. Категории образуют иерархию, поэтому категория может быть просто другой подчиненой категорией (подкатегория). Категория имеет только имя и никаких других свойств.* 

 * *Каждому читателю присваивается уникальный номер. У читателя есть Фамилия, Имя, адрес и день рождения. Читатель может взять один или несколько экземпляров книг. При взятии книги записывается запланированая дата возврата.*

**Связи:**

***Category <---> Category:***  категории могут включать в себя еще категории (как бы рекурсивная связь)

***Category <---> Book:***  многие ко многим, так как каждую книгу можно отнести к множеству категорий, к каждой категории может относиться множество книг. Связываем через отношение assigned.

***Book <---> Publisher:***  один ко многим, так как у каждой книги только один издатель, но каждый издатель может издать множество книг. Связываем через отношение published.

***Book <---> Copy:***  многие к одному, так как у книги может быть много копий, но копия соответствует только одной книге. Связываем через отношение has.

***Copy <---> Reader:***  один ко многим, так как одна копия может быть взята только одним человеком, но один человек может взять много копий. Связываем через taken.


**Задача 2**

**Условие задачи**

*Смоделируйте следующие отношения в E/R.*

  *  *Квартира расположена в доме на улице в городе в стране*

  *  *Две команды играют друг против друга в футбол под руководством арбитра*

  *  *У каждого человека (мужчины и женщины) есть отец и мать*
  

**2.1**
*Все связи через located.*
***Apartment <---> House:*** один ко многим, так как в одном доме много квартир, но одна квартира относится только к одному дому.

***House <---> Street:*** один ко многим, так как каждый дом расположен только на одной улице, но на каждой улице может быть много домов.

***Street <---> City:*** один ко многим, так как каждая улица может быть только в своем одном городе, но в каждом городе много улиц.

***City <---> Country:*** один ко многим, так как каждый город в своей единственной стране, но в каждой стране много городов.



**2.2**

***Team <---> Match:*** многие ко многим, так как матч играют несколько команд, а команды могут играть несколько матчей. Связываем через played.

***Match <---> Referee:*** один ко многим, так как каждый матч судит только один рефери, но каждый рефери может судить несколько матчей. Связываем через judged.


**2.3**

***Human <---> Mother:*** один ко многим, так как у каждого человека может быть только одна мать, но у матери может быть много детей. Связываем через has.

***Match <---> Father:*** один ко многим, так как у каждого человека может быть только один отец, но у отца может быть много детей. Связываем через has.