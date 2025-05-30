# 📰 InNews - Modern News App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="License">
</div>

<div align="center">
  <h3>🚀 A beautiful, modern news application built with Flutter</h3>
  <p>Stay informed with the latest news from around the world</p>
</div>

---

## ✨ Features

### 🎨 **Modern UI/UX**
- **Material Design 3** with custom theming
- **Dark & Light Mode** support with system preference detection
- **Smooth Animations** using Flutter Staggered Animations
- **Responsive Design** that works on all screen sizes
- **Custom Gradient Themes** with beautiful color schemes

### 📱 **Core Functionality**
- **Real-time News** from NewsAPI with multiple categories
- **Advanced Search** with query suggestions and recent searches
- **Bookmark System** to save articles for later reading
- **Offline Reading** with intelligent caching
- **Share Articles** with friends and social media
- **Reading Time Estimation** for better user experience

### 🔧 **Technical Features**
- **Clean Architecture** with proper separation of concerns
- **State Management** using Riverpod for reactive programming
- **Local Storage** with Hive for fast data persistence
- **Network Caching** for improved performance
- **Error Handling** with user-friendly error messages
- **Pull-to-Refresh** for latest content updates

---

## 🏗️ Architecture

InNews follows **Clean Architecture** principles with a well-organized folder structure:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App-wide constants
│   ├── network/            # API client and network layer
│   ├── storage/            # Local storage services
│   ├── theme/              # App theming and styles
│   └── utils/              # Utility functions
├── features/               # Feature-based modules
│   ├── home/               # Home screen and related widgets
│   ├── search/             # Search functionality
│   ├── bookmarks/          # Bookmark management
│   ├── article/            # Article detail view
│   └── navigation/         # App navigation
└── shared/                 # Shared components
    ├── models/             # Data models
    ├── providers/          # State management
    └── widgets/            # Reusable UI components
```

---

## 🛠️ Tech Stack

### **Frontend**
- **Flutter 3.x** - Cross-platform UI framework
- **Dart 3.x** - Programming language
- **Material Design 3** - Design system

### **State Management**
- **Riverpod** - Reactive state management

### **Networking**
- **Dio** - HTTP client with interceptors
- **Retrofit** - Type-safe API client generation
- **JSON Serialization** - Automatic model generation

### **Storage**
- **Hive** - Fast NoSQL database for local storage
- **SharedPreferences** - Simple key-value storage

### **UI/UX**
- **Google Fonts** - Beautiful typography
- **Cached Network Image** - Efficient image loading
- **Shimmer** - Loading animations
- **Flutter Staggered Animations** - Smooth transitions

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- NewsAPI key (free from [newsapi.org](https://newsapi.org))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/hasnainmakada-99/InNews.git
   cd InNews
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure API Key**
   
   Update the API key in `lib/core/constants/app_constants.dart`:
   ```dart
   static const String apiKey = 'YOUR_NEWS_API_KEY_HERE';
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎯 Key Features Explained

### 🏠 **Home Screen**
- **Category Filtering**: Browse news by categories (Technology, Sports, Business, etc.)
- **Infinite Scrolling**: Seamlessly load more articles as you scroll
- **Pull-to-Refresh**: Get the latest news with a simple pull gesture
- **Smart Caching**: Articles are cached for offline reading

### 🔍 **Search Functionality**
- **Real-time Search**: Find articles as you type
- **Search Suggestions**: Popular topics and recent searches
- **Advanced Filtering**: Filter by date, source, and relevance
- **Search History**: Quick access to previous searches

### 🔖 **Bookmark System**
- **One-tap Bookmarking**: Save articles instantly
- **Offline Access**: Read bookmarked articles without internet
- **Swipe to Delete**: Easy bookmark management
- **Sync Across Sessions**: Bookmarks persist between app launches

### 📖 **Article Reader**
- **Clean Reading Experience**: Distraction-free article view
- **Reading Time**: Estimated time to read each article
- **Share Integration**: Share articles via social media or messaging
- **External Link**: Open full articles in browser

---

## 🎨 Design System

### **Color Palette**
```dart
Primary: #6366F1 (Indigo)
Secondary: #8B5CF6 (Purple)
Accent: #06B6D4 (Cyan)
Error: #EF4444 (Red)
Success: #10B981 (Green)
Warning: #F59E0B (Amber)
```

### **Typography**
- **Font Family**: Inter (Google Fonts)
- **Responsive Text Scaling**: Adapts to system font size
- **Consistent Hierarchy**: Clear information hierarchy

### **Animations**
- **Staggered List Animations**: Smooth item appearances
- **Hero Transitions**: Seamless navigation between screens
- **Loading Shimmer**: Elegant loading states
- **Micro-interactions**: Delightful user feedback

---

## 🔧 Configuration

### **API Configuration**
Update `assets/config/app_config.json`:
```json
{
  "api": {
    "baseUrl": "https://newsapi.org/v2",
    "apiKey": "YOUR_API_KEY",
    "timeout": 30000
  },
  "features": {
    "enableBookmarks": true,
    "enableSearch": true,
    "enableSharing": true,
    "enableOfflineMode": true
  },
  "ui": {
    "defaultTheme": "system",
    "enableAnimations": true,
    "pageSize": 20
  }
}
```

### **App Constants**
Modify `lib/core/constants/app_constants.dart` for:
- API endpoints and keys
- Cache duration settings
- UI configuration
- Feature flags

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### **Contribution Guidelines**
- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **NewsAPI** for providing the news data
- **Flutter Team** for the amazing framework
- **Material Design** for the design system
- **Open Source Community** for the incredible packages

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/hasnainmakada-99/InNews/issues)
- **Discussions**: [GitHub Discussions](https://github.com/hasnainmakada-99/InNews/discussions)
- **Email**: hasnainmakada99@gmail.com

---

<div align="center">
  <p>Made with ❤️ by <a href="https://github.com/hasnainmakada-99">Hasnain Makada</a></p>
  <p>⭐ Star this repo if you found it helpful!</p>
</div>
