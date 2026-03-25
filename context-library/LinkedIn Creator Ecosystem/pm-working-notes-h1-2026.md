# PM Working Notes: Scope, Surfaces, and Constraints (H1 2026)

**Squad**: Creator Ecosystem - Publishing & Composer

---

## 1. Our Scope (What We Actually Own)

Our squad owns the "Creation" layer. If it happens before the post hits the database, it's ours.

**The Composer UI**: The global "Start a post" modal across all platforms (Desktop Web, iOS, Android). This includes the text area, formatting tools, media attachments, and the final "Post" button.

**The Drafting Infrastructure**: The auto-save microservices, scheduled posts API, and the state management of a post while it's being written.

**Pre-Publish Interventions**: We own the business logic that runs right before a post is finalized. (For example: our current logic that flags "You mentioned Microsoft, do you want to tag them?" or "Your video is still processing").

**Creator Analytics**: The "Post Performance" dashboard where creators view their impressions, engagements, and audience demographics after the fact.

---

## 2. Out of Scope (What We Do NOT Own)

We cannot solve this problem by tweaking downstream distribution.

**The Feed Ranking Algorithm**: We do not own the Feed. We cannot assign a "spam score" to a post and tell the Feed Relevance team to down-rank it. That is their jurisdiction.

**Trust & Safety (T&S) Moderation**: We are not the content police. If a post violates terms of service, T&S handles it. Using ChatGPT to write a generic post is not a TOS violation. We cannot ban users, and we cannot block them from posting just because their content is "boring."

**The LinkedIn Learning / Premium AI Bots**: Other teams are building "Career Coach" chatbots. We are strictly focused on the public feed posting experience.

---

## 3. Hard Technical Constraints (The "Reality Check")

This is the most critical part for the PRD. I cannot design a feature that violates these engineering constraints:

**Latency Budget (< 500ms SLA)**: The "Post" button has a strict P99 latency SLA of 500 milliseconds. Users expect posting to be instant. This means we cannot send the full text of a post to a massive, synchronous LLM (like GPT-4) when they click 'Post'. The user would be left staring at a loading spinner for 3 seconds, which will tank our completion metrics.

**Compute Cost**: LinkedIn sees millions of posts drafted daily. Running a heavy GenAI inference on every single keystroke or draft state would cost millions of dollars a month in compute.

**Mobile Parity**: Any intervention we design (e.g., an "Authenticity Check" modal) must work seamlessly on iOS and Android, which means we can't rely on heavy client-side processing that drains user batteries.

---

*Source: PM Working Notes, H1 2026*
