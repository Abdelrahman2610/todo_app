# Flutter To-Do List Application

A modern, feature complete task management application built with Flutter and Dart.

----------------------------------------------------------------------------------

## Overview

This is a mobile to-do list application designed to help users organize their daily tasks efficiently. The app provides a clean, intuitive interface with powerful features like task categorization, priority management, and comprehensive filtering options.

----------------------------------------------------------------------------------

## Core Features

**Task Management**
- Create new tasks with detailed information
- Edit existing tasks
- Mark tasks as complete or incomplete
- Delete tasks with confirmation
- Reorder tasks via drag-and-drop

**Organization**
- Five task categories: Work, Personal, Shopping, Health, and Study
- Three priority levels: High, Medium, and Low
- Optional due dates with automatic overdue detection
- Add notes and descriptions to tasks

**Search and Filter**
- Real-time search across task titles and notes
- Filter tasks by category
- Filter tasks by priority level
- Multiple sorting options (date, alphabetical, priority, category, due date)

**Analytics**
- View completion statistics
- Track progress by category and priority
- Monitor overdue and upcoming tasks
- Visual progress indicators

**Interface**
- Light and dark theme support
- Material Design 3 components
- Smooth animations and transitions
- Responsive layout for different screen sizes

----------------------------------------------------------------------------------

## Technical Details

**Framework:** Flutter 3.0+  
**Language:** Dart 3.0+  
**State Management:** StatefulWidget with setState  
**Persistence:** In-memory (no database)  
**Architecture:** Widget-based component structure

----------------------------------------------------------------------------------

## Project Structure

```
lib/
├── main.dart                      # Application entry point
├── models/
│   ├── task.dart                  # Task data model
│   └── task_enums.dart            # Priority, category, sort enums
├── screens/
│   ├── todo_screen.dart           # Main task screen
│   └── statistics_screen.dart     # Analytics screen
├── widgets/
│   ├── task_tile.dart             # Task list item
│   ├── add_task_input.dart        # Quick add bar
│   ├── search_bar_widget.dart     # Search component
│   ├── filter_chips.dart          # Filter UI
│   └── task_detail_dialog.dart    # Task editor dialog
└── theme/
    └── app_theme.dart             # Theme configuration
```

----------------------------------------------------------------------------------

## Setup Instructions

1. Install Flutter SDK from https://flutter.dev/docs/get-started/install

2. Create a new Flutter project:
```bash
flutter create todo_app
cd todo_app
```

3. Replace the default `lib` folder with the provided source code maintaining the folder structure shown above.

4. Install dependencies:
```bash
flutter pub get
```

5. Run the application:
```bash
flutter run
```

Select your target device (emulator or physical device) when prompted.

----------------------------------------------------------------------------------

## How to Use

**Adding Tasks**
- Tap the input bar at the bottom of the screen
- Enter task title (required)
- Select priority and category
- Optionally add notes and due date
- Save the task

**Managing Tasks**
- Tap checkbox to toggle completion status
- Tap task to edit details
- Tap delete icon or swipe left to delete
- Long-press and drag to reorder

**Searching and Filtering**
- Use search bar to find tasks by title or notes
- Tap filter icon to show category and priority filters
- Tap sort icon to change sorting order
- Filters and search work together

**Viewing Analytics**
- Tap analytics icon in app bar
- View completion rates and task breakdowns
- See overdue and upcoming task counts

**Changing Theme**
- Tap the theme toggle button (floating button)
- Switches between light and dark modes

----------------------------------------------------------------------------------
## Requirements

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- iOS 11.0+ or Android SDK 21+
- Development tools: VS Code, Android Studio, or IntelliJ IDEA

## Build and Deploy

**For Android:**
```bash
flutter build apk --release
```

**For iOS:**
```bash
flutter build ios --release
```

Note: iOS builds require a macOS system with Xcode installed.

## Limitations

- No data persistence between sessions
- No cloud synchronization
- No user authentication
- No recurring tasks
- No notifications or reminders
- Single user only

----------------------------------------------------------------------------------
