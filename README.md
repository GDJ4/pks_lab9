# Отчёт по практическому занятию №8
## Выполнил: Лазарев Г.С. 
## Группа: ЭФБО-10-23

## Ход работы:

### 1. Создание проекта Supabase и ключей

С созданием проекта, были получены Project URL и Anon (public) key. На стороне Supabase была создана таблица notes со следующей схемой:
```
id uuid (PK, default: gen_random_uuid())
title text
done bool
created_at timestamp tz (default now())
```
Для таблицы notes были включены политики Row Level Security по заданию

### 2. Зависимости

В pubspec.yaml были добавлены зависимости supabase_flutter и flutter_dotenv:
```dart
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  supabase_flutter: ^2.5.1 # Или актуальная версия
  flutter_dotenv: ^5.1.0 # Или актуальная версия
```

### 3. Контрольные скриншоты

<img width="510" height="493" alt="image" src="https://github.com/user-attachments/assets/8828bf00-f537-443b-a721-ceca2556af49" /><img width="458" height="385" alt="image" src="https://github.com/user-attachments/assets/7420deb3-455c-4f77-9336-f35dfb9cbe25" />

<img width="362" height="816" alt="image" src="https://github.com/user-attachments/assets/62cbccff-6a26-4ed2-b160-64ce4e2bf47a" /><img width="972" height="215" alt="image" src="https://github.com/user-attachments/assets/1ea0d705-42a1-42b5-95df-5ea106048f1e" />

<img width="376" height="836" alt="image" src="https://github.com/user-attachments/assets/595d80e0-4212-4aea-8eaf-1644706f1038" /><img width="955" height="193" alt="image" src="https://github.com/user-attachments/assets/05d79c70-606e-454f-b3f7-f11998779a01" />



