# ToDoshka

Приложение для создания и ведения задач. Реализован список задач, показ количества выполненных дел, свайпы, важность и дедлайны, редактирование и быстрое добавление.

## Основной экран

На этом экране показан список задач. По клику на задачу или на кнопку "плюс" осуществляется переход на вторичный экран. В конце списка есть быстрое добавление задачи.

## Экран детальной информации (редакттирования и создания задачи)

Создан вторичный экран, доступный из основного либо по клику на задачу, либо по клику на кнопку "плюс". На этом экране можно изменить уже существующую задачу, ввести данные новой задачи или удалить задачу. Можно заполнить такие данные: сам текст задачи, важность задачи, если она есть, и дедлайн, если он есть.

## Реализовано 

- Основной экран: отображение списка дел, быстрое добавление новых
- По свайпу задачи можно отмечать ее выполненой или удалять.
- Дополнительный экран: экран, доступный из основного, для редактирования и добавления задач 
- Код отформатирован + flutter lints
- Разделение проекта на слои
- Прикреплен APK-файл
- Кастомная иконка приложения
- Логирование
- Реализована работа с бэкендом
- Реализована offline база данных
- State management
- Интернационализация
- Обработка серверных ошибок 
- Тестирование

## Показ работы приложения

![Работа приложения](gif/1.gif)    

## Начало работы

Чтобы запустить приложение:

```bash
  git clone https://github.com/deeelis/todoshka.git
  cd todoshka
  Flutter flutter pub get
  flutter run
```

Либо можете установить с помощью APK-файла, который находится в папке apk

## Статус проекта

В разработке..

