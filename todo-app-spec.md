# TaskFlow — Project Specification
*(working title — rename as you like)*

A premium, offline-first to-do app. Android first, built in Flutter so iOS and Windows are a straight port later. Design is the priority: black-and-white, polished SVG iconography, buttery-smooth animations, and enough small satisfying touches that using it daily feels good, not just functional.

---

## 1. Core Philosophy

- **Offline-first.** No account, no login, no server dependency for core use.
- **Design-first.** Every interaction should have a considered animation — not decoration for its own sake, but feedback that makes actions feel *satisfying* (completing a task, adding one, swiping it away).
- **Monochrome by default.** Black/white/grayscale as the primary theme, with a single accent color reserved for state (e.g. overdue, priority) — used sparingly so it actually means something.
- **Fast.** 60fps minimum everywhere, no jank on mid-range Android devices, not just flagships.

---

## 2. Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Framework | Flutter (Dart) | Custom pixel-perfect rendering, official desktop targets for future Windows port, strong animation primitives |
| Local DB | Drift (SQLite) | Type-safe queries, reactive streams pair naturally with Flutter widgets |
| State management | Riverpod | Testable, scales well, avoids boilerplate of Bloc for a project this size |
| Local notifications | `flutter_local_notifications` | Cross-platform scheduling, works offline |
| Audio (voice notes) | `record` + `just_audio` | Lightweight recording + playback, no cloud/transcription needed |
| Icons | Custom SVG set via `flutter_svg` | Consistent, scalable, no icon-font blur |
| Animation | Flutter's implicit animations + `flutter_animate` for choreography, `Hero` for shared-element transitions | Covers 95% of needs without hand-rolled `AnimationController` everywhere |

---

## 3. Design System

### 3.1 Theme
- **Base palette:** true black (`#000000`) or near-black (`#0A0A0A`) background in dark mode, pure white / off-white (`#FAFAFA`) in light mode. Grayscale for hierarchy (use 5–6 defined gray steps, not arbitrary opacity hacks).
- **One accent color**, chosen once, used only for: overdue tasks, active reminders, the "add task" FAB. Suggested: a single warm red or electric blue — pick one, don't mix.
- **Both light and dark mode** are required, not optional — system-follows by default, manual override in settings.
- **Typography:** one clean sans-serif (e.g. Inter, Manrope, or SF-Pro-adjacent). Strong type scale: task title should visually dominate; metadata (due time, tags) stays small and gray.

### 3.2 Iconography
- Fully custom SVG icon set — not a stock icon pack. Consistent stroke width, consistent corner radius, consistent grid (e.g. 24x24).
- Icons should have **two states** where relevant (outline = inactive, filled = active) so state changes register visually, not just via color.
- Category/tag icons can carry more personality than system icons (settings, back, etc.), which should stay minimal.

### 3.3 Motion Principles
- **Every state change animates.** No jump cuts on: task added, task completed, task deleted, screen transitions, checkbox toggle.
- **Standard durations:** micro-interactions 150–250ms, screen transitions 300–400ms, celebratory moments (streak milestone) up to 600ms. Nothing should feel slow.
- **Easing:** avoid linear/default curves everywhere — use `Curves.easeOutCubic` or custom curves for a "snappy but soft" feel, not robotic.
- **Signature moments to nail:**
  - Checking off a task: checkbox fill animation + subtle strike-through animation on text + task slides/fades to bottom of list or into "completed" section.
  - Adding a task: FAB morphs into the input sheet (shared-element style), not a hard modal pop-in.
  - Swipe-to-complete / swipe-to-delete: icon reveal scales in as you swipe, with haptic feedback at the commit threshold.
  - Pull-to-refresh or pull-to-add: custom, not the default Android spinner.
  - Empty states: don't just show gray text — a subtle looping SVG illustration/animation ("all done for today" with a small motion).

### 3.4 Haptics
- Light haptic on task completion, on swipe-commit, and on reminder snooze — makes the app feel physically responsive, not just visually.

---

## 4. Core Features (MVP)

- **Daily view** — today's tasks front and center, clearly split into pending / completed.
- **Task creation**
  - Title (required)
  - Description (optional, expandable field — not always visible, keeps the add-flow fast)
  - Due date + time
  - Optional voice note attached to the task
  - Priority (e.g. none / low / medium / high — represented by subtle marker, not loud colors)
  - Optional tag/category
- **Reminders**
  - Exact-time local notifications (`AlarmManager` under the hood on Android)
  - Notification actions: mark done, snooze (15 min / 1 hr / tomorrow) directly from the notification
  - Recurring tasks: daily, weekly, custom (e.g. every Mon/Wed/Fri)
- **Voice notes**
  - Tap-and-hold or tap-to-record mic button on task creation
  - Waveform or simple duration + play button on the task card
  - Stored locally as compact audio files, referenced by path in DB
- **Completion tracking**
  - Clear visual distinction between done/not-done
  - Simple streak or completion-rate indicator (e.g. "5-day streak", small ring/progress indicator) — this is a strong "make me want to open it daily" hook
- **Search & filter** — by tag, priority, date range
- **Swipe gestures** — swipe right to complete, swipe left to delete (or reverse, per settings)
- **Home screen widget** — today's task list + quick-add, since this drives daily engagement

## 5. Stretch Features (post-MVP, but design for extensibility now)

- Subtasks / checklists within a task
- Task templates for recurring routines
- Calendar view (week/month), not just daily
- Simple stats screen (weekly completion trends — small charts, still monochrome)
- Custom accent color unlock as a reward for streaks (nice retention hook, still respects "one accent at a time" rule)
- Backup/export to a local file (JSON) — keeps it offline but gives users a safety net
- iOS port (Flutter — should require UI polish pass, not a rewrite)
- Windows desktop port (Flutter desktop target — adjust layouts for larger screens, add keyboard shortcuts)

---

## 6. Data Model (draft)

```
Task
├── id: String (uuid)
├── title: String
├── description: String?
├── dueDateTime: DateTime?
├── isRecurring: bool
├── recurrenceRule: String?      // e.g. RRULE-style string
├── priority: enum (none, low, medium, high)
├── tagId: String?
├── voiceNotePath: String?
├── isCompleted: bool
├── completedAt: DateTime?
├── createdAt: DateTime
└── updatedAt: DateTime

Tag
├── id: String
├── name: String
└── iconRef: String              // maps to custom SVG set

Reminder
├── id: String
├── taskId: String (FK)
├── triggerTime: DateTime
├── isSnoozed: bool
└── snoozeUntil: DateTime?
```

---

## 7. Reminders — Implementation Notes (Android)

- Use `AlarmManager.setExactAndAllowWhileIdle()` for precision — `WorkManager` is not exact enough for "remind me at 3:00pm."
- Request `SCHEDULE_EXACT_ALARM` permission (Android 12+); handle the case where the user revokes it gracefully, with an in-app prompt to re-enable.
- Some OEMs (Xiaomi, Samsung, Oppo) aggressively kill background alarms — prompt users to whitelist the app from battery optimization on first reminder setup.
- Notification should support inline actions (Done / Snooze) without opening the app.

---

## 8. Voice Notes — Implementation Notes

- `record` package for capture → save as compact `.m4a` in app-local storage.
- Store only the file path in the DB, not the audio blob.
- `just_audio` for playback — a simple play/pause + duration label is enough for v1; a waveform visual is a nice v2 polish item.
- No transcription, no cloud upload — purely a local audio memo attached to a task.

---

## 9. Updates & Distribution

Two paths depending on where you distribute:

**If sideloading (APK via GitHub Releases):**
Don't hand-roll an update checker. Point users to **Obtainium** — a dedicated Android app that tracks GitHub Releases and prompts users to install updates. This avoids building your own version-check/download/install flow and the APK-signature headaches that come with it.

**If publishing to Google Play:**
Use Google's **In-App Update API** instead — smoother UX, no "install from unknown sources" friction, and users trust it more.

Recommendation: start on Play Store if possible (much better user trust and update experience); keep GitHub Releases + Obtainium as a parallel option for users who prefer sideloading.

---

## 10. Definition of "Done" for v1

- [ ] Add/edit/delete tasks with title, optional description, optional voice note
- [ ] Due date + exact-time reminder with snooze/done notification actions
- [ ] Daily view with clear pending/completed split, smooth completion animation
- [ ] Swipe gestures with haptic feedback
- [ ] Recurring tasks (daily/weekly/custom)
- [ ] Light + dark mode, full custom SVG icon set, single accent color
- [ ] Home screen widget
- [ ] Streak/completion indicator
- [ ] Offline-only, no crashes on airplane mode
- [ ] 60fps on a mid-range test device (not just an emulator or flagship)

---

## 11. Notes for the Developer

The bar here isn't "functional to-do app" — it's "an app that feels good enough to open every single day." When in doubt on any interaction, ask: *does this feel snappy and satisfying, or does it feel like a form?* If it feels like a form, add motion, add haptic, or simplify the flow until it doesn't.
