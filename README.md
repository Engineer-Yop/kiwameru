# 極める Kiwameru — Learning Apps

Duolingo-style learning apps: a skill path, bite-size lessons, quizzes (multiple choice, fill-in-the-blank, put-in-order), XP, streaks, hearts, achievements and real-world **build missions**.

| App | What you master | Open | Android |
|---|---|---|---|
| **OpsDojo** | Junior DevOps engineer in 12 weeks — Linux, Bash, networking, Docker, GitHub Actions, AWS, Terraform, Ansible, Kubernetes, Prometheus/Grafana, DevSecOps | [Open](https://engineer-yop.github.io/kiwameru/opsdojo/) | [APK](https://github.com/Engineer-Yop/kiwameru/releases/latest/download/opsdojo.apk) |
| **DevQuest** | Software engineering for the IBM Philippines Consulting OJT — Git, Java, SQL, React, Spring Boot, testing, cloud, AI, Agile, interviews | [Open](https://engineer-yop.github.io/kiwameru/devquest/) | [APK](https://github.com/Engineer-Yop/kiwameru/releases/latest/download/devquest.apk) |

**Home page:** https://engineer-yop.github.io/kiwameru/

## Install on your phone

**iPhone / iPad** — open the app link in **Safari** → Share → **Add to Home Screen**. It launches full-screen like a native app and works offline.

**Android** — either open the app link in Chrome → ⋮ → **Install app**, or download the **APK** above and allow "Install unknown apps" for your browser.

## How it's built

- `docs/` — the static web apps (one self-contained `index.html` each), plus PWA manifest, icons and an offline service worker. GitHub Pages serves this folder from `main`.
- Android APKs are built by wrapping each app with [Capacitor](https://capacitorjs.com) and attached to the **android** release.

Each app keeps its content in one block between `/*@@CONTENT_START@@*/` and `/*@@CONTENT_END@@*/` (`CONFIG` + `UNITS`). The rest is the shared engine. To make a new path, copy an app folder and replace only that block.

## Notes

- Progress is saved on the device (localStorage).
- The AI mentor chat and build-mission code reviews use Claude and work when the app is opened on claude.ai. In the installed app they show a note instead; everything else works offline.
- The App Store (iOS) and Play Store need paid developer accounts ($99/year Apple, $25 one-time Google). The Home Screen install above needs neither.
