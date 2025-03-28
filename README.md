📌 Overview

This is a Flutter-based quiz app that dynamically generates multiple-choice quiz questions using GROQ.com LLM APIs. The app does not require a backend and fetches quiz questions on demand. Users can select difficulty levels and categories for personalized quiz experiences.

🎯 Features

Dynamic Quiz Generation: Fetches quiz questions in real-time via GROQ.com LLM APIs.

Difficulty & Category Selection: Allows users to choose quiz difficulty and category.

Single Question Display: Displays one question at a time for an immersive experience.

Feedback Mechanism: Shows correct/incorrect feedback instantly.

Score Tracking: Keeps track of correct answers and displays results at the end.

Retry Option: Allows users to regenerate a fresh quiz.

Optional Enhancements:

Timer per question

Local storage for tracking past scores

🛠️ Tech Stack

Framework: Flutter

State Management: Bloc

API Integration: HTTP requests to GROQ.com APIs

Local Storage: Hive (for storing past scores)

📂 Project Structure

quiz_app_test/
│── lib/
│   ├── main.dart               # Entry point of the app
│   ├── screens/
│   │   ├── home_screen.dart    # Home screen with quiz start button
│   │   ├── quiz_screen.dart    # Displays questions and handles answers
│   │   ├── result_screen.dart  # Shows quiz results
│   ├── models/
│   │   ├── quiz_question.dart  # Quiz question model
│   ├── repository/
│   │   ├── quiz_repository.dart # Handles API requests
│   ├── api/
│   │   ├── api_client.dart     # API client for making requests
│── pubspec.yaml                # Dependencies and project metadata
│── README.md                   # Project documentation

🚀 Getting Started

Prerequisites

Install Flutter SDK

Configure a Flutter environment

Obtain an API key from GROQ.com

Installation

Clone the repository:

git clone https://github.com/yourusername/quiz_app_test.git

Navigate to the project directory:

cd quiz_app_test

Install dependencies:

flutter pub get

API Configuration

Update the API key in quiz_repository.dart:

final ApiClient apiClient = ApiClient(apiKey: "your_groq_api_key");

Run the App

To start the app on an emulator or physical device:

flutter run

🌐 API Integration

GROQ.com API Request Format

{
  "model": "llama3-8b-8192",
  "messages": [
    {
      "role": "system",
      "content": "Generate exactly 5 multiple-choice questions on the topic of **CATEGORY**. The difficulty level should be **DIFFICULTY**. Each question should have 4 options, with one correct answer clearly marked. Return the response as a valid JSON array only."
    }
  ]
}

Response Format

[
  {
    "question": "What is the capital of France?",
    "options": ["Berlin", "Madrid", "Paris", "Rome"],
    "correctAnswer": "Paris"
  }
]

🏗️ Future Enhancements

Add a timer per question.

Implement animations for better user experience.

Improve UI with custom themes and sounds.

🤝 Contribution

Feel free to contribute! Fork the repo, create a branch, and submit a pull request.

📜 License

This project is licensed under the MIT License.