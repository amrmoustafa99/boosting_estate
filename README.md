# Boost Listing Feature (Flutter)

A clean and scalable Flutter implementation of a real estate boosting system designed to simulate real marketplace behavior with a modern Arabic-first user experience.

The project focuses on:

- Clean architecture and reusable widgets
- Smooth and intuitive UX
- Real-world boosting flow simulation
- Dynamic pricing and eligibility validation
- Professional UI inspired by production marketplace apps

> ⚠️ Note: This project uses mock/local data only. No backend, API, or payment gateway integration is included.

---

# Features

## Listing Integration
- Boost action accessed directly from the listing item
- Listing data passed directly to the Boost page
- Listing eligibility validation before boosting
- Active boost state preview

## In-App Featured Boost
- Minimum duration: 3 days
- Duration increases in 3-day increments only
- Dynamic pricing based on selected duration
- Counter-based duration selector
- Expiry validation against listing expiration date
- Renew listing action when selected duration exceeds allowed limit

## Push Notifications
- Instant push notification boosting
- Slot-based availability simulation
- Daily-limit handling
- Disabled state when daily quota is consumed
- Clear Arabic status messaging

## Instagram Promotion
- Multiple promotion formats:
  - Story
  - Post
  - Reel
- Dynamic pricing
- Multi-selection support

## WhatsApp Promotion
- Scheduled WhatsApp campaign simulation
- Queue/slot availability handling
- Validation and processing state simulation

## Pricing & Validation
- Real-time total calculation
- Smart selection constraints
- Dynamic order summary
- Multi-service support
- Validation feedback with user-friendly messaging

## Success Flow
- Processing states:
  - Active
  - Pending
- Order summary preview
- Navigation back to listing

---

# Screens

## 1. Listing Page
- Property details
- Boost button
- Active boost status
- Remaining boost days

## 2. Boost Page
- Multiple boost services
- Duration selector
- Eligibility validation
- Disabled urgent state handling
- Dynamic pricing summary
- Sticky action button

## 3. Success Page
- Success confirmation
- Boost order summary
- Processing state
- Return navigation

---

# Demo Video
https://drive.google.com/file/d/1q0mP5RM5pIbhov2R8Vwu7SOF_C7saop1/view?usp=sharing


# Project Structure

```bash
lib/
├── main.dart
├── core/
│   └── theme/
│       └── app_theme.dart
│
├── features/
│   └── boost/
│       ├── models/
│       │   ├── boost_option.dart
│       │   ├── boost_selection_state.dart
│       │   └── listing_model.dart
│       │
│       ├── services/
│       │   └── boost_queue_service.dart
│       │
│       ├── views/
│       │   ├── boost_page.dart
│       │   ├── listing_page.dart
│       │   ├── renew_page.dart
│       │   └── success_page.dart
│       │
│       └── widgets/
│           ├── boost_button.dart
│           ├── days_selector.dart
│           ├── in_app_boost_card.dart
│           ├── instagram_boost_card.dart
│           ├── price_summary.dart
│           ├── push_notification_card.dart
│           └── whatsapp_boost_card.dart
│
└── generated/
    └── assets.dart
