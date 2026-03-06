# Implementation Plan - Goals & Chat

## Goal Description
Implement the **Goal Planner** and **AI Chat** features to complete the core functionality of Antigravity.

## Proposed Changes

### Feature: Goal Planner
#### [MODIFY] [goals_screen.dart](file:///c:/my_app/lib/features/goals/goals_screen.dart)
- Convert to `ConsumerStatefulWidget`.
- Display list of `Goal` items from `storageProvider`.
- Add "Create Goal" Floating Action Button showing a dialog or bottom sheet.
    - Fields: Title, Target Amount, Current Amount, Deadline.
- On goal creation, trigger `GeminiService.generateGoalPlan` to get an AI action plan.
- expand goal card to show the AI-generated plan.

### Feature: AI Chat
#### [MODIFY] [chat_screen.dart](file:///c:/my_app/lib/features/chat/chat_screen.dart)
- Convert to `ConsumerStatefulWidget`.
- Implement a chat UI with `ListView` of messages.
- Input field to send messages.
- Use `geminiProvider.chatStream` to get responses.
- Pass recent transaction context to Gemini for context-aware answers.

## Verification Plan

### Manual Verification
1.  **Goals**:
    - Create a goal/
    - Verify it saves to Hive.
    - Verify AI plan is generated and displayed.
2.  **Chat**:
    - Open Chat tab.
    - Send "How much did I spend this month?".
    - Verify AI responds (mock or real response depending on API key validity).
    - Verify typing animations/loading states.
