# Cardify
Simplified Studying

## Overview

Cardify is a sophisticated Flutter-based cross-platform application designed to simplify note-taking and studying. This app provides an intuitive and user-friendly interface for managing digital documents, including the creation of folders, adding documents, and categorizing them as starred or trashed. It features a dynamic and interactive flip card system for question-answer reviews, making it ideal for educational purposes or personal knowledge management. This pair with the two APIs allows for user creation and question-answer creation via a Large Language Model. This application generates specific question-answer pairs based on your notes. This Question Generation API uses Natural Language Processing to create questions from provided content dynamically. It is built with FastAPI and integrates with language models for question-answer generation. The API also includes user verification to ensure only authorized users can request question generation.


## Features

-**Folder Hierarchy Management**: Create, edit, and organize folders and subfolders to categorize documents efficiently.

-**Document Handling**: Add, edit, and manage documents with ease. Each document can include rich text content and a set of question-answer pairs that are ideal for study purposes.

-**Dynamic Search Functionality**: Quickly find folders and documents with a built-in search feature that updates results as you type.

-**Starred Documents**: Mark important documents or folders as starred for quick access.

-**Trash Management**: Move unwanted documents and folders to the trash for temporary storage with options to restore or permanently delete them.

-**Flip Card System**: Engage with interactive flip cards that display questions and reveal answers upon interaction, enhancing the learning and review process.

-**Profile Management**: View and manage user profile details from within the app.

-**Login System**: Secure access to the application with username and password through a RESTful API.

-**Rich Text Editing**: Utilize rich text editing capabilities to format document content, including bold, italic, underline, and text color adjustments.

-**Navigation System**: Navigate through the app with a bottom navigation bar that provides quick access to home, starred items, trash, and the user profile.

-**LLM powered practice generation**: Generate personalized questions based on your own notes.

-**User Verification**: Ensures that only registered and verified users can use the API.

-**Dynamic Question Generation**: Generates questions based on the provided text content.

-**Immediate Responses**: Quickly processes and returns generated questions along with their answers.

## Technologies Used

- **Flutter**: For creating the mobile application.
- **Dart**: Programming language used for writing application logic.
- **Flutter Quill**: A rich text editor used for document editing features.
- **Flip Card**: For implementing the interactive flip cards used in the question-answer review system.
- **HTTP**: For API interactions to handle user authentication and data fetching.
- **FastAPI**: For the LLM API.
- **Flask**: For the USER auth API.

## Setup and Installation
You will need to run both APIs and the Flutter app.
*Based on ports that are being used you will need to update the endpoints in each CREDS.json

For the Flutter application
1. **Clone the repository:**
   ```
   git clone https://github.com/yourrepository/document-manager.git
   ```
2. **Navigate to the project directory:**
   ```
   cd myapp
   ```
3. **Install dependencies:**
   ```
   flutter pub get
   ```
4. **Run the application:**
   ```
   flutter run
   ```
For the USER API
1. **Navigate to the project directory:**
   ```
   cd USER_API
   ```
2. **Install dependencies:**
   ```
    pip install requirement.txt
   ```
3. **Run the application:**
   ```
   python3 app.py
   ```
For the LLM API
1. **Navigate to the project directory:**
   ```
   cd LLM_API
   ```
2. **Install dependencies:**
   ```
    pip install requirement.txt
   ```
3. **Run the application:**
   ```
   python3 app.py
   ```
