# Discourse Debates Plugin

A full-featured **Debate Workflow Plugin** for Discourse.

This plugin introduces a structured debate process built around two stages:

1️⃣ **Suggestion Box Phase** – users submit hypothesis proposals and vote to decide which ones deserve a debate.
2️⃣ **Open Debate Phase** – if a suggestion reaches the configured threshold, it automatically becomes a debate with structured participation tools.

It is built to support **serious structured decision-making**, community brainstorming, policy discussions, ideation platforms, governance boards, and moderated communities.

---

## ✨ Features

### ✅ Suggestion Box Phase

- Users submit **hypothesis proposals** inside a “Suggestion Box” category.
- Other users can **vote (like-style)** on the suggestion.
- Comments are blocked during this stage to prevent biased discussion.
- Users can optionally **vote anonymously**.
- After a configurable time window (default: 7 days):

  - If votes ≥ configured threshold (default: 10), it **automatically becomes a debate**
  - Otherwise it expires and is archived.

---

### ✅ Debate Phase

Once promoted to debate:

- Topic automatically moves to a Debate category
- Comments become enabled
- Still **no replies to replies** — users may only comment directly on the original topic post (prevents branching arguments)
- Users get a **stance selector (radio group)**:

  - 👍 Support
  - 😐 Neutral
  - 👎 Against

- Users can optionally **hide their identity**
- A **right-side debate statistics panel** shows:

  - Support count
  - Neutral count
  - Against count
  - Participation total
  - Time remaining (if configured)

---

### ✅ Admin & Moderation Tools

Includes a full **Admin Analytics UI**:

- Number of debates created
- Conversion rate (suggestion → debate)
- Average vote counts
- Most supported debates
- Most controversial debates
- Time-to-conversion metrics
- Exportable data
- Basic charts

Accessible in:

```
Admin → Plugins → Debate Analytics
```

---

## 🏗️ Architecture Overview

This plugin extends Discourse with full backend + frontend functionality.

### Backend (Rails)

Models:

- `DebateSuggestion`
- `DebateVote`
- `DebateSupportPosition`

Jobs:

- Scheduled background job checks daily for expired suggestions
- Automatically promotes successful suggestions
- Archives failed ones

API:

- JSON API endpoints for voting
- Endpoints to set debate stance
- Admin analytics endpoints

Security:

- Respects Discourse permissions
- Category-based access control
- Anonymity protection logic included

---

### Frontend (Ember / Theme Layer)

UI Components:

- Suggestion vote panel
- Debate stance selector (radio)
- Right sidebar analytics component
- Vote counters
- Permission UI locks during suggestion stage

Behavior:

- Real-time updates where supported
- Progressive enhancement
- Pure Discourse-compatible frontend

---

## 🧩 Requirements

- Discourse (self-hosted)
- Ruby compatible with your Discourse version
- Admin access to install plugins

---

## 🔧 Installation

SSH into your Discourse server.

1️⃣ Navigate to your plugins folder:

```
cd /var/discourse
```

2️⃣ Edit your container config:

```
sudo nano containers/app.yml
```

Inside the `plugins:` section, add:

```
- git clone https://github.com/Rethinking-the-Wine-Industry/discourse-debate
```

3️⃣ Rebuild Discourse:

```
sudo ./launcher rebuild app
```

---

## ⚙️ Configuration

After installation, go to:

```
Admin → Settings → Plugins → Discourse Debates
```

You will find configuration options:

| Setting                          | Description                              |
| -------------------------------- | ---------------------------------------- |
| debate_suggestion_category       | The category used for Suggestion Box     |
| debate_open_category             | Where accepted debates move to           |
| debate_required_votes            | Minimum votes to become a debate         |
| debate_suggestion_duration_days  | Lifetime of suggestion before evaluation |
| debate_allow_anonymous_votes     | Allow hidden voters                      |
| debate_allow_anonymous_positions | Allow anonymous stance in debates        |
| debate_sidebar_enabled           | Enable right-side metrics panel          |

---

## 📦 Setting Up the Suggestion Box (Mandatory Step)

### Step 1 – Create Parent Debate Category

Create a parent category:

```
Debates
```

This will serve as the main hub.

---

### Step 2 – Create Suggestion Box Subcategory

Create a new subcategory:

```
Debates → Suggestion Box
```

This is where users create hypothesis proposals.

---

### Step 3 – Set Permissions

Recommended permissions:

- Everyone: Create Topics
- Reply: Disabled
- Moderators/Admins: Full Control

This ensures no discussions occur during this phase.

---

### Step 4 – Link It in Plugin Settings

Go to plugin settings and assign:

```
debate_suggestion_category = Suggestion Box
```

---

### Step 5 – Configure Threshold & Time

Example recommended config:

```
debate_required_votes = 10
debate_suggestion_duration_days = 7
```

This means:
Users submit → community votes → after 7 days plugin decides automatically.

---

## 🗣️ Debate Phase Behaviour

When a Suggestion is approved:

- Topic moves to Debate category
- A debate header appears
- Users may now comment
- Replies to replies are blocked
- Users may select Support / Neutral / Against
- Sidebar displays statistics live

If anonymous mode enabled:

- Users may toggle identity disclosure
- Admins may still see true data

---

## 👩‍💼 Admin Analytics Panel

Navigate to:

```
Admin → Plugins → Debate Analytics
```

You will see:

- Total suggestions
- Total debates
- Failure rate
- Participation counts
- Conversion analytics
- Charts and tables

This is extremely useful for:

- Community health monitoring
- Governance reports
- Organizational decision processes

---

## 🔍 Data Storage

The plugin stores data in:

- Custom tables for suggestions
- Custom tables for votes
- Custom tables for stance positions

No core Discourse tables are modified.

---

## 🧪 Testing

Recommended:

- Create 3 users
- Create Suggestion
- Vote with each
- Wait for auto conversion (or trigger manually in Admin Panel)
- Participate in debate
- Check analytics

---

## 🚧 Roadmap

Planned future features:

- Debate closing verdict tool
- Weighted voting
- Custom stance labels
- Timeline graph visualization
- Webhook integrations
- API documentation
- Badges & gamification integration
- Translations

---

## 🛟 Support

This project is intended for developers.
If you need professional help implementing or extending it:

- Open an issue
- Or contact your platform administrator

---

## 📜 License

MIT License
Use freely in commercial or personal platforms.

---

If you want, I can also:

- tailor wording to a more corporate tone
- rephrase for open-source community style
- add screenshots placeholders
- include contribution guidelines
- add changelog template
