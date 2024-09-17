# AI Math Tutor iOS App Implementation Guide

## 1. Application Overview

The AI Math Tutor is an iOS app designed to help students solve math problems using AI. Key features include:
- Capturing photos of math questions using the device camera
- AI-powered analysis and solution generation
- Step-by-step explanations of problem-solving processes
- Follow-up question functionality
- History of past questions and answers

## 2. File Structure

```
ai tutors/
└── ai tutors/
    ├── ai_tutorsApp.swift
    ├── Info.plist
    ├── Assets.xcassets/
    ├── Views/
    │   ├── HomeView.swift
    │   ├── ImageReviewView.swift
    │   ├── AITutorAnswerView.swift
    │   └── HistoryView.swift
    ├── Models/
    │   ├── Question.swift
    │   └── Answer.swift
    ├── ViewModels/
    │   ├── CameraViewModel.swift
    │   ├── ImageProcessingViewModel.swift
    │   └── AITutorViewModel.swift
    ├── Services/
    │   └── OpenAIService.swift
    └── Utils/
        └── ImageUtils.swift
```

## 3. Core Functionalities and Implementation Guide

### 3.1 Home Screen with Camera
#### Files: HomeView.swift, CameraViewModel.swift

1. Implement `HomeView.swift`:
   - Create a SwiftUI view that displays a full-screen camera preview.
   - Add a text overlay at the top: "Take a pic of your homework".
   - Include a button at the bottom for capturing photos.

2. Implement `CameraViewModel.swift`:
   - Use AVFoundation to handle camera operations.
   - Implement methods for initializing the camera, capturing photos, and handling camera permissions.

3. In `HomeView.swift`, use `CameraViewModel` to manage camera functionality.

### 3.2 Image Review and Confirmation
#### Files: ImageReviewView.swift, ImageProcessingViewModel.swift

1. Implement `ImageReviewView.swift`:
   - Create a SwiftUI view that displays the captured image.
   - Implement an interactive bounding box with draggable corner points (16px dots).
   - Add an overlay outside the bounding box.
   - Include confirmation (✅) and cancel (🔙) buttons.

2. Implement `ImageProcessingViewModel.swift`:
   - Create methods for managing the bounding box state (position, size).
   - Implement image cropping based on the bounding box coordinates.

3. In `ImageReviewView.swift`, use `ImageProcessingViewModel` to handle bounding box interactions and image processing.

### 3.3 AI Tutor Answer
#### Files: AITutorAnswerView.swift, AITutorViewModel.swift, OpenAIService.swift

1. Implement `OpenAIService.swift`:
   - Create methods for sending API requests to OpenAI.
   - Implement image encoding and sending to the "gpt-4o-2024-08-06" model.
   - Use structured output for generating reasoning steps and final answers.

2. Implement `AITutorViewModel.swift`:
   - Create methods for managing the AI interaction flow.
   - Handle the processing of AI responses and updating the UI.

3. Implement `AITutorAnswerView.swift`:
   - Create a SwiftUI view that displays the AI's answer in a visually appealing format.
   - Implement a chat UI for follow-up questions.

4. In `AITutorAnswerView.swift`, use `AITutorViewModel` to manage the AI interaction and display results.

### 3.4 History/Archive
#### Files: HistoryView.swift, Question.swift, Answer.swift

1. Implement `Question.swift` and `Answer.swift`:
   - Define data models for storing question images, AI responses, and timestamps.

2. Implement `HistoryView.swift`:
   - Create a SwiftUI view that displays a list of past questions and answers.
   - Implement navigation to view full details of past interactions.

3. Update `ai_tutorsApp.swift`:
   - Implement a tab bar with 'Home' and 'History' options.
   - Use `UITabBarController` to manage navigation between main views.

## 4. Additional Implementation Notes

1. Use SwiftUI for building the user interface across all views.
2. Implement MVVM architecture: Views observe ViewModels, which manage business logic and data.
3. Use Combine framework for reactive programming and managing asynchronous events.
4. Ensure proper error handling and user feedback throughout the app.
5. Implement data persistence for storing question history (consider using CoreData or SwiftData).
6. Follow Apple's Human Interface Guidelines for a consistent and user-friendly design.
7. Implement proper memory management, especially when handling large images.
8. Ensure all UI updates occur on the main thread.
9. **Important Note for Developers**: Always use the "gpt-4o-2024-08-06" model when making requests to the OpenAI API. This specific model should be used for all AI interactions in the app, including image analysis and question answering. Do not use GPT-4 Vision or any other model variants. Ensure that all API calls in `OpenAIService.swift` explicitly specify "gpt-4o-2024-08-06" as the model.

## 5. OpenAI API Integration

When integrating with the OpenAI API, follow these guidelines:

1. API Requests:
   - Always set the `model` parameter to "gpt-4o-2024-08-06" in your API requests.
   - Use the chat completions endpoint: `https://api.openai.com/v1/chat/completions`

2. Structured Output:
   - Implement structured output as shown in the provided curl example.
   - Use the `response_format` parameter with `"type": "json_schema"` to ensure structured responses.

3. Image Handling:
   - When sending images to the model, use base64 encoding.
   - Include the encoded image in the `content` array of the user message.

Example API request structure:

```swift
let payload: [String: Any] = [
    "model": "gpt-4o-2024-08-06",
    "messages": [
        [
            "role": "user",
            "content": [
                [
                    "type": "text",
                    "text": "Solve this math problem"
                ],
                [
                    "type": "image_url",
                    "image_url": [
                        "url": "data:image/jpeg;base64,\(base64EncodedImage)"
                    ]
                ]
            ]
        ]
    ],
    "response_format": [
        "type": "json_schema",
        "schema": {
            "type": "object",
            "properties": {
                "steps": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "explanation": { "type": "string" },
                            "output": { "type": "string" }
                        },
                        "required": ["explanation", "output"]
                    }
                },
                "final_answer": { "type": "string" }
            },
            "required": ["steps", "final_answer"]
        }
    ]
]
```

Ensure that all developers working on the project are aware of the specific model requirement and implement the API integration accordingly.

## 6. Key Considerations

1. Performance: Optimize image processing and API calls to ensure smooth user experience.
2. Error Handling: Implement robust error handling for network issues, API errors, and invalid user inputs.
3. Accessibility: Ensure the app is accessible to users with disabilities by following iOS accessibility guidelines.
4. Testing: Implement unit tests for core functionalities and UI tests for critical user flows.
5. Privacy: Handle user data securely and provide clear privacy policies regarding the use of AI and data storage.
6. Scalability: Design the app architecture to allow for easy addition of new features or AI capabilities in the future.

By following this implementation guide, developers should be able to create a functional and user-friendly AI Math Tutor iOS app that leverages the power of the "gpt-4o-2024-08-06" model for accurate and helpful math problem-solving assistance.