# Final Project — Supabase Flutter App

This repository contains a small Flutter app scaffolded to satisfy the course milestones: a working Flutter app with Supabase integration (auth, CRUD, storage) and instructions to run locally and deploy to the web (Netlify) or produce an Android APK.

Overview
- Flutter app (web + mobile)
- Supabase backend for authentication, a simple `items` table, and a `public` storage bucket for images

Important files
- `lib/` — Flutter app source
- `lib/services/supabase_service.dart` — Supabase init and helpers
- `lib/screens/` — UI (auth, home, add item)
- `db/create_items_table.sql` — SQL to create the `items` table
- `.env.example` — environment variable examples for local runs

Quick local run (web)
1. Install Flutter and ensure `flutter` is on your `PATH`.
2. Install dependencies and run the app in Chrome:

```powershell
cd 'c:\Users\NITRO V15\final_proj'
flutter pub get
$env:SUPABASE_URL = 'https://your-project.supabase.co'
$env:SUPABASE_ANON_KEY = 'your-anon-key'
flutter run -d chrome
```

Replace the `SUPABASE_*` values with your project's values or use `.env` tooling.

Supabase setup
1. Create a Supabase project at https://app.supabase.com
2. Create a storage bucket named `public` (or update the bucket name in the code)
3. Run the SQL migration in `db/create_items_table.sql` in the SQL editor to create the `items` table.
4. Get the `anon` public API key and project URL (Project Settings → API)

SQL migration (`db/create_items_table.sql`)
- creates a table called `items` with `user_id` to scope items to users

Netlify (Flutter web) deployment
Option A — Netlify drag-and-drop (quick):
1. Build the web app:

```powershell
flutter build web
```

2. Open Netlify and create a new site → drag-and-drop the `build/web` folder into Netlify.

Option B — Deploy from Git (recommended for CI):
1. Push your repo to GitHub.
2. In Netlify, choose "New site from Git" → connect the repo.
3. Set the build command to `flutter build web` and the publish directory to `build/web`.
4. Add environment variables (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) to Netlify site settings.

Android signed APK (quick notes)
1. Follow Flutter docs to generate a signing key and configure `android/key.properties`.
2. Build a release APK:

```powershell
flutter build apk --release
```

Then distribute `build/app/outputs/flutter-apk/app-release.apk`.

Troubleshooting notes
- If you see SDK errors relating to the Supabase Dart package, try running `flutter pub upgrade` and verify you are using a compatible `supabase_flutter` version.
- If images do not load, make sure your storage bucket allows public reads or generate signed URLs.

Next steps you can ask me to do
- Initialize git and create branches + initial commits
- Add unit/widget tests for the core screens
- Wire up CI (GitHub Actions) for Netlify or automatic web builds

---
If you want, I will initialize a Git repo here and make the first commits and a `feature/` branch.
# final_proj

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
