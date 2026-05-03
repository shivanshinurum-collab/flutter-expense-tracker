# Expense Tracker - Project Documentation

## 1. Project Overview (App ka Use)
**Expense Tracker** ek powerful aur user-friendly mobile application hai jo users ko unke daily expenses aur income ko track karne me madad karta hai. Iska main objective financial management ko asan banana hai taaki users apne kharche (expenses) aur bachat (savings) par control rakh sakein.

### Main Purpose:
- Daily transactions record karna.
- Financial data ko charts ke through analyze karna.
- Budget set karna aur use track karna.
- Recurring expenses aur bill reminders manage karna.

---

## 2. Key Features (Sare Features)
Is app me modern financial tracking ke liye bahut saare premium features diye gaye hain:

*   **Transaction Management**: Income aur Expense ko easily add, edit aur delete karne ki suvidha.
*   **Multi-Account Support**: Bank accounts, Cash, aur Wallets ko alag-alag manage karein.
*   **Category Management**: Kharcho ko categories me divide karein (e.g., Food, Transport, Rent).
*   **Visual Analytics**: Bar charts aur Pie charts ke zariye kharcho ka real-time analysis.
*   **Budget Planning**: Monthly ya weekly budget set karein aur overspending se bachein.
*   **Recurring Transactions**: Wo kharche jo har mahine hote hain (jaise Rent ya Subscriptions), unhe automate karein.
*   **Bill Reminders**: Apne bills ki due dates miss na karein, app aapko remind karayega.
*   **Search & Filter**: Purane transactions ko search bar ya filters se turant dhundhein.
*   **Onboarding Flow**: Naye users ke liye step-by-step setup guide.
*   **Theme Management**: Dark mode aur Light mode ka support.
*   **Security**: Data locally save hota hai, jo privacy ensure karta hai.

---

## 3. Technology Stack (Kispe Bana Hai)
Ye project modern technologies aur libraries ka upyog karke banaya gaya hai:

-   **Framework**: [Flutter](https://flutter.dev/) (Cross-platform development ke liye).
-   **Programming Language**: Dart.
-   **State Management**: [GetX](https://pub.dev/packages/get) (Fast aur lightweight state management ke liye).
-   **Database**: [SQFlite](https://pub.dev/packages/sqflite) (Local storage/SQL database).
-   **Charts**: [FL Chart](https://pub.dev/packages/fl_chart) (Beautiful graphs aur charts ke liye).
-   **Icons & Fonts**: Font Awesome Icons aur Google Fonts (Poppins, OpenSans).
-   **Preferences**: Shared Preferences (Small settings data store karne ke liye).

---

## 4. App Modules (Internal Structure)
App ka code modular architecture me divided hai taaki maintenance asan ho:

1.  **`accounts`**: User ke different payment methods manage karta hai.
2.  **`analysis`**: Data ko visual form (Charts) me convert karta hai.
3.  **`budgets`**: Budget limits set aur monitor karne ke liye logic.
4.  **`categories`**: Icons ke saath custom categories create karne ke liye.
5.  **`home`**: Dashboard jahan summary dikhti hai.
6.  **`recurring`**: Periodic transactions ka handling.
7.  **`reminders`**: Upcoming payments ki list.
8.  **`theme`**: UI appearances (Colors/Fonts) control karta hai.
9.  **`settings`**: User preferences aur app configurations.

---

## 5. Project Directory Structure
```text
lib/
├── extensions/       # Dart language extensions for extra functionality
├── models/           # Data structures (Transaction, Account, Category models)
├── modules/          # Feature-wise screens and controllers (GetX)
├── repositories/     # Data handling logic (Database queries)
├── widgets/          # Reusable UI components (Custom Buttons, Cards)
└── main.dart         # App ka entry point
```

---

## 6. How to Run (Install Kaise Karein)
1.  **Flutter SDK** installed hona chahiye.
2.  Command line me run karein: `flutter pub get` (Dependencies install karne ke liye).
3.  Device connect karein aur run karein: `flutter run`.

---

## 7. Developer & Support
Ye app ek learning aur utility project hai. Isme privacy ka khaas dhyan rakha gaya hai kyunki sara data local device par hi rehta hai.
