# Boost Listing Feature (Flutter)

A clean and well-structured Flutter implementation of a Boosting System for real estate listings, designed to simulate real-world marketplace behavior.
This project focuses on:
- Clear user experience (UX)
- Simple and intuitive UI
- Clean and scalable code structure

> ⚠️ Note: This project uses mock data only (no backend or payment integration).

---

## Features

Multiple boost services (In-App, Push, Instagram, WhatsApp)
In-App boost with unit-based duration pricing (3-day units)
Real-time total price calculation
Multi-selection support with smart constraints (e.g. Push types)
Slot-based scheduling (Push & WhatsApp)
Eligibility validation with clear user feedback
Order summary with dynamic updates
Success flow with Active / Pending processing states

---

## Screens

### 1. Listing Page
Property details
"Boost Listing" button (based on eligibility)
Boost status (Active / Remaining days)

### 2. Boost Page
Select one or multiple boost services
Eligibility validation per card
Duration + unit breakdown (In-App)
Slot preview (Push / WhatsApp)
Live pricing updates
Sticky total summary

### 3. Success Page
Order summary
Processing status (Active / Pending)
Navigation back to listing

---

## Screenshots

> Add your screenshots here after running the app

### Listing Page
<img width="393" height="850" alt="image" src="https://github.com/user-attachments/assets/34caf5ef-7359-43cf-8270-365cc5c1f5cc" />

### Boost Page
<img width="396" height="851" alt="image" src="https://github.com/user-attachments/assets/11109f1b-590e-445d-a5f7-3e953feb4698" />
<img width="390" height="855" alt="image" src="https://github.com/user-attachments/assets/57a62685-92f6-4403-8e33-70d9bcbb40fb" />
<img width="394" height="845" alt="image" src="https://github.com/user-attachments/assets/a0501f90-1d72-4641-b4ff-48785e7950c6" />
<img width="399" height="848" alt="image" src="https://github.com/user-attachments/assets/dbd9ea69-7cc5-4868-b755-4df1c0653050" />
<img width="392" height="855" alt="image" src="https://github.com/user-attachments/assets/ab17f7e4-58aa-4b46-b9ae-49cf93be02b2" />
<img width="395" height="849" alt="image" src="https://github.com/user-attachments/assets/6aaadf9a-e2c9-49bd-a351-ba28e0184951" />

### Success Page
<img width="393" height="846" alt="image" src="https://github.com/user-attachments/assets/fa3509a5-38b7-4b23-b257-60c42625f191" />

### Boosted Active Page
<img width="394" height="842" alt="image" src="https://github.com/user-attachments/assets/5cc9b5b4-1e37-4099-9357-5e65b351b165" />

### For test Preview State
### Expired State
<img width="394" height="844" alt="image" src="https://github.com/user-attachments/assets/3784f9fb-49c7-4141-95fb-c78420940a1d" />

### Expiring State
<img width="400" height="854" alt="image" src="https://github.com/user-attachments/assets/532c74e1-0bc0-4b63-8cc7-555c3cba0043" />

### Boosted State
<img width="395" height="839" alt="image" src="https://github.com/user-attachments/assets/ed371704-90c8-48f6-b2e6-6eea9dc6fdbf" />

---

## Project Structure

```bash
lib/
├── main.dart
├── core/
│   └── theme/
│       └── app_theme.dart
├── features/
│   └── boost/
│       ├── models/
│       │   ├── boost_option.dart
│       │   ├── boost_selection_state.dart
│       │   └── listing_model.dart
│       ├── services/
│       │   └── boost_queue_service.dart
│       ├── views/
│       │   ├── boost_page.dart
│       │   ├── listing_page.dart
│       │   ├── renew_page.dart
│       │   └── success_page.dart
│       └── widgets/
│           ├── boost_button.dart
│           ├── days_selector.dart
│           ├── in_app_boost_card.dart
│           ├── instagram_boost_card.dart
│           ├── price_summary.dart
│           ├── push_notification_card.dart
│           └── whatsapp_boost_card.dart
├── generated/
│   └── assets.dart
