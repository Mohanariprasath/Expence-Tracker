# Antigravity Finance App - Walkthrough

## Overview
Antigravity is a premium personal finance app built with Flutter and powered by Gemini AI.

## Project Structure
- **lib/core**: Theme, Constants, Services (Gemini), Utils (ChartUtils), Providers.
- **lib/data**: Models (Hive optimized), Storage Service.
- **lib/features**:
  - **Home**: AI Smart Tips, Recent Transactions, **Add Transaction Dialog**.
  - **Dashboard**: Interactive Charts (Bar & Pie) powered by `fl_chart`.
  - **Goals**: **Goal Planner** with AI-generated strategy plans.
  - **Chat**: **AI Assistant** for financial advice and transaction queries.
  - **Settings**: API Key management, Theme toggle.

## Features Implemented
1.  **Dashboard Charts**: Visualizes weekly income/expense and category breakdown.
2.  **Goal Planner**:
    - Create financial goals (e.g., "New Laptop", "Emergency Fund").
    - Automatic **AI Strategy Plan** generation for each goal.
    - Track progress visually.
3.  **AI Chat**:
    - Chat with "Antigravity" assistant.
    - Context-aware answers based on your recent transactions.
4.  **Transaction Management**:
    - Add Income/Expense with date and category.
    - View recent transactions on Home screen.

## How to Run
1. **Dependencies**:
   ```bash
   flutter pub get
   flutter pub run build_runner build
   ```
2. **Run App**:
   ```bash
   flutter run
   ```

## Setup Instructions
1. Open the app.
2. Go to **Settings** tab.
3. Enter your **Gemini API Key** and save.
4. Go to **Home**, tap `+` to add some transactions.
5. Check **Dashboard** for charts and **Goals** to set targets.
6. Chat with the **Assistant** for insights.
