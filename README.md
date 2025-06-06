# ✅ Flutter To-Do List App (Task 2)

A simple yet polished to-do list application built with **Flutter**. This app allows users to create,delete, and manage tasks locally using **Hive** for persistent storage. Designed for both functionality and smooth user experience.

---

## 🚀 Features

- ✅ Add new tasks with titles and due dates
- ☑️ Mark tasks as completed or pending
- 📅 View deadlines, sorted by due date
- 🧠 Offline data persistence using **Hive**
- 🗑️ Swipe to delete with **Undo**
- 🎨 Clean, modern UI with Material 
- 📦 Modular code structure for scalability

---

## 📦 Dependencies

```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.1.1
build_runner: ^2.4.6
hive_generator: ^2.0.1
-----------------------------------------------------------------------------------------------------------------
📁 Project Structure

lib/
├── models/                # Task data model (Hive)
├── services/              # Hive service logic
├── widgets/               # Reusable components
│   ├── task_item.dart
│   └── ui_sections/
│       ├── input_section.dart
│       └── task_list.dart
├── screens/               # UI logic and state
│   └── home_screen.dart
└── main.dart              # App initialization

-----------------------------------------------------------------------------------------------------------------
🧰 Getting Started

1- Clone the repo:
. git clone https://github.com/your-username/todo_flutter_task2.git
cd todo_flutter_task2
2- Install dependencies:
.flutter pub get
3- Generate Hive adapters:
. flutter pub run build_runner build
4- Run the app:
. flutter run


