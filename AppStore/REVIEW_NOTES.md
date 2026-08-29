# App Review notes — Ahar 1.0

Ahar is **fully offline**. It does not use the network, sign-in, or In-App Purchase. Ahar is an offline foodIQ / AharIQ nutrition reference.

## First launch

On first launch the app imports bundled JSON (`foods.json`, `sources.json`) into on-device SwiftData. This can take a moment and does **not** require Wi-Fi or cellular. After import, later launches skip this step.

If you test in Airplane Mode from a cold install, that is expected and supported.

## Suggested test path

1. Enable **Airplane Mode**.
2. Launch Ahar.
3. Wait until Home appears (search field: “Search food, spice, ingredient…”).
4. Search **anar** — result should include **Pomegranate**.
5. Search **haldi** — result should include **Turmeric**.
6. Search **manjal** — result should include **Turmeric**.
7. Open Pomegranate. Confirm nutrition per 100 g (example: 83 kcal) and regional names.
8. Change quantity to 200 g and confirm calories scale (example: 166 kcal). Try Custom quantity as well.
9. Tap the heart to favorite. Open the Favorites tab and confirm the food is listed.
10. Return to Home and confirm **Recently viewed** includes the food you opened.
11. Open Settings and read the data / not-medical-advice notes.

## Demo vs curated data

Some foods are marked **demo** in the UI. Those are sample records for development, not composition-table authoritative rows. Pomegranate in V1 is the schema example citing IFCT 2017 by name.

## What you will not find

- Login, registration, or forgot-password
- Web views that load remote content
- Ads, analytics prompts, ATT tracking prompt
- HealthKit permission dialogs

## Contact

Arun Kumar  
Email: arunkumar6207@gmail.com  
Phone: +91 80198 97589  

There is no backend to whitelist. The app has no demo account because there is no sign-in.
