<div align="center">
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/flutter-logo.svg" width="100" alt="Flutter Logo"/>
  <h1>💸 Expense Tracker pro & Antigravity AI</h1>
  <p><i>A next-generation, AI-powered personal finance manager built with Flutter.</i></p>

  <!-- Badges -->
  <p>
    <img alt="Flutter Version" src="https://img.shields.io/badge/Flutter-3.10.4+-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
    <img alt="Dart Version" src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
    <img alt="Platform" src="https://img.shields.io/badge/Platforms-iOS%20%7C%20Android-lightgrey?style=for-the-badge"/>
    <img alt="Status" src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge"/>
  </p>
</div>

---

## 📖 Overview

**Expense Tracker** is a comprehensive Flutter-based application designed to help you manage your financial life effortlessly. What sets this app apart is its deep integration with **Antigravity AI Assistant**. The application not only tracks your transactions but actively understands your spending behavior to provide highly contextual financial advice, structured goals, and synthesized monthly reports.

Say goodbye to complex spreadsheets and hello to an intuitive, artificially intelligent finance manager.

---

## ✨ Key Features

### 📊 **Intelligent Dashboard**
- **Unified Overview:** Instantly view your total balance alongside your most recent income and expenses.
- **Smart Insights:** A dynamic banner generates daily financial tips on your home screen based on your recent transactions (powered by Antigravity).
- **Categorized Spending:** Distinct visualization for expenses vs. income.

### 🤖 **Antigravity AI Personal Assistant**
Built right into the application, tap the chat bubble and talk directly to your personal financial advisor.
- **Ask Anything:** "How can I reduce my dining out expenses?"
- **Monthly Reports:** Type `"Monthly Report"` to get a synthesized evaluation of your recent spending.
- **Goal Planning:** Type `"Plan"` or `"Goal"` and the AI will analyze your financial data to help you save for your next milestone (e.g., a New Car).

### 🎨 **Beautiful & Modern UI**
- **Material 3 Design:** Fully leverages Flutter's implementation of Material 3 for a fluid, accessible, and native-feeling user experience.
- **Deep Purple Aesthetic:** A clean, calming, and focused color palette designed for minimum cognitive load.
- **Smooth Animations:** Integrated scroll behaviors and fluid list interactions.

---

## � Screenshots *(Placeholders)*

| Dashboard | AI Chat Assistant |
| :---: | :---: |
| <img src="https://via.placeholder.com/250x500.png?text=Dashboard+Screenshot" width="200" alt="Dashboard"> | <img src="https://via.placeholder.com/250x500.png?text=AI+Chat+Screenshot" width="200" alt="Chat View"> |

---

## 🏗️ Architecture & Project Structure

The project follows a modular, scalable architecture, separating core logic from features for maintainability.

```text
lib/
 ├── main.dart                   # 🚀 Application Entry Point
 └── src/
      ├── core/
      │    └── models/           # 📦 Data schemas (Transaction, Goal)
      └── features/
           ├── antigravity/      # 🧠 AI Module: Chat screen & Antigravity AI Services
           └── dashboard/        # 🏠 User UI: Home screen, Smart Tips, Balance widgets
```

---

## 🛠️ Technology Stack

- **Frontend Framework:** [Flutter](https://flutter.dev/) 
- **Language:** [Dart](https://dart.dev/)
- **State Management:** *Stateful Widgets (Designed to easily scale to Provider/Riverpod)*
- **AI Integration:** Antigravity AI Engine
- **Design System:** Material UI 3

---

## 🚀 Getting Started

To get a local copy of this project up and running, follow these steps.

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.10.4`)
- Dart SDK
- Android Studio or Visual Studio Code with Flutter extensions.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/expence_tracker.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd expence_tracker
   ```

3. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 💡 Trying out the AI

Because this is a showcase, the app currently uses mock financial metadata to demonstrate the AI integration without requiring backend configuration.

1. Launch the app to the **Home Screen**.
2. Tap the **Chat Bubble Icon** in the top right.
3. Chat with the bot! Try commands like:
   - *"Give me my monthly report"*
   - *"Help me plan my goal"*

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<div align="center">
  <b>Built with ❤️ using Flutter and Antigravity AI</b>
</div>
