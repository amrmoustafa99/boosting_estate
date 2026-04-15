# Boost Listing Feature (Flutter)

A clean and well-structured Flutter implementation of a **Boosting Feature** for a real estate listing.

This project focuses on:
- Clear user experience (UX)
- Simple and intuitive UI
- Clean and scalable code structure

> ⚠️ Note: This project uses mock data only (no backend or payment integration).

---

## Features

- ✅ Multiple boost options (In-App, Push, Instagram, WhatsApp)
- ✅ In-App boost with duration selection (3 / 6 / 9 days)
- ✅ Real-time total price calculation
- ✅ Multi-selection support
- ✅ Boost status (Active / Remaining days)
- ✅ Extend boost flow
- ✅ Clean UI with reusable components

---

## Screens

### 1. Listing Page
- Shows property details
- "Boost Listing" button (if not boosted)
- "Extend Boost" + status badge (if boosted)

### 2. Boost Page
- Select one or multiple boost options
- Choose duration for In-App boost
- Live price updates
- Sticky price summary
- CTA button with total price

### 3. Success Page
- Shows selected boost items
- Displays status (Active / Pending)
- Navigate back to listing

---

## Screenshots

> Add your screenshots here after running the app

### Listing Page
<img width="397" height="860" alt="image" src="https://github.com/user-attachments/assets/2e19f08c-7879-4b39-a752-7a84a6d16555" />

### Boost Page
<img width="398" height="850" alt="image" src="https://github.com/user-attachments/assets/55a55472-9793-4a16-a9e9-151ef1607b73" />

### Success Page
<img width="396" height="848" alt="image" src="https://github.com/user-attachments/assets/24364bed-a69b-453b-9741-734490e52768" />

### Boosted Active Page
<img width="396" height="848" alt="image" src="https://github.com/user-attachments/assets/67471347-9a6b-4944-9e0a-6d1cd99dd329" />

---

## Project Structure

```bash
lib/
├── main.dart
├── core/
│   └── theme/
│       └── app_theme.dart
└── features/
    └── boost/
        ├── models/
        │   ├── boost_option.dart
        │   ├── listing_model.dart
        │   └── boost_selection_state.dart
        ├── views/
        │   ├── listing_page.dart
        │   ├── boost_page.dart
        │   └── success_page.dart
        └── widgets/
            ├── boost_option_card.dart
            ├── days_selector.dart
            ├── price_summary.dart
            └── boost_button.dart
