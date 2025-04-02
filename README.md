# Prayer Cycle - Zúme

A small application for tracking and managing your prayer life.

## Overview

This application helps users track and manage their prayer life. Key features include:

- Create and manage prayer lists
- Track prayer requests and answers
- Persistent storage so your prayers are saved locally
- Clean, minimalist interface focused on the prayer experience
- Works offline as a Progressive Web App (PWA)
- Mobile-friendly responsive design

## Prayer Timer Features

The app includes a comprehensive prayer timer that guides users through different prayer segments:

### Prayer Sections
1. **PRAISE** - Begin with worship and adoration
2. **WAIT** - Quiet time for listening and reflection
3. **CONFESS** - Time for confession and repentance
4. **READ** - Scripture reading and meditation
5. **INTERCEDE** - Intercessory prayer for others
6. **PRAY** - Personal prayer requests
7. **THANKS** - Expressing gratitude
8. **SING** - Worship through song
9. **WAIT** - Additional time for listening
10. **PRAISE** - Closing with worship

Each section is set to 5 minutes (300 seconds) by default, providing a structured 50-minute prayer session.

### Timer Features
- Visual countdown timer for each section
- Play/pause functionality
- Automatic progression to the next section
- Section titles and descriptions displayed in the user's preferred language
- Beautiful section-specific background images

### Audio Feedback
- A gentle beep sound plays when transitioning between prayer sections
- Audio feedback helps maintain focus without requiring visual attention

## Target Platforms
The app is available on:
- iOS
- Android
- macOS

## Build web and deploy
```bash
flutter build web
ghp-import -n -p -f build/web
```
