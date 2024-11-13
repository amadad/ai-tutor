<div align="center">

<img width="100px" src="./Assets.xcassets/AppIcon.imageset/AppIcon.png" />

# AI Math Tutor

### iOS Math Problem Solver with Step-by-Step Explanations

<p>
<img alt="Swift Version" src="https://img.shields.io/badge/Swift-5.9-orange" />
<img alt="Platform iOS" src="https://img.shields.io/badge/Platform-iOS%2017.0+-blue" />
<img alt="License" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
</p>

</div>

-----

<p align="center">
  <a href="#-overview">Overview</a> •
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-requirements">Requirements</a>
</p>

-----

## 📖 Overview

AI Math Tutor helps students solve math problems by taking a photo and getting AI-powered step-by-step explanations. The app uses OpenAI's gpt-4o-2024-08-06 model to analyze problems and provide detailed solutions.

## ✨ Features

- 📸 Capture homework problems with camera
- 🎯 Interactive cropping with adjustable bounding box
- 🤖 AI-powered problem analysis
- 📝 Step-by-step solution explanations
- 💬 Follow-up questions support
- 📚 History of past questions and answers

## 📱 Installation

1. Clone the repository
2. Open `ai tutors.xcodeproj`
3. Add your OpenAI API key to `OpenAIService.swift`
4. Build and run

## 🏗 Architecture

### File Structure

- **Views**: SwiftUI-based UI components
- **ViewModels**: MVVM architecture with Combine
- **Services**: OpenAI API integration
- **Models**: Data structures for questions/answers
- **Utils**: Image processing helpers

## 🚀 Usage

1. Launch app and allow camera access
2. Take photo of math problem
3. Adjust crop area with bounding box
4. Confirm to send to AI for analysis
5. View step-by-step solution
6. Ask follow-up questions if needed

## ⚙️ Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- OpenAI API key
- Camera access

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
