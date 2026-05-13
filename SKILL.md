---
user-invocable: true
name: mece
description: Composable MECE (Mutually Exclusive, Collectively Exhaustive) decomposition protocol. Use directly via /mece [problem] or reference from other skills as a thinking primitive for structured breakdown.
tokens: ~450
cloud-ok: true
---

# MECE Protocol

**MECE = Mutually Exclusive, Collectively Exhaustive**

- **Mutually Exclusive:** Categories don't overlap (no double-counting)
- **Collectively Exhaustive:** Categories cover everything (nothing missing)

## Protocol (the composable core)

This is the reusable algorithm. Other skills reference this section directly.

1. **Accept** the problem statement
2. **Anchor on known identities (MANDATORY)** — check the Known Identity Library below. If the problem maps to a known identity, you MUST use that identity as your level-1 structure. Do not rearrange, combine, or substitute with a "more nuanced" alternative. The identity is the decomposition. Refine within its branches, not around them. Example: "margins shrinking" maps to Profit = Revenue - Costs → level 1 MUST be Revenue-side and Cost-side, not a 3-way or thematic split. **Domain disambiguation:** when a problem could match identities from different domains (e.g., "underperforming" could be business or technical), infer domain from context — codebase/engineering context = technical identities, strategy/business context = business identities. If genuinely ambiguous with no context clues, ask which domain before decomposing.
3. **Decompose** into 3-7 top-level categories. Fewer than 3 usually means you haven't split enough. More than 7 means you need a higher-level grouping.
4. **Self-test ME** — for every pair of categories, ask: "Could a single item legitimately belong in both?" If yes, redraw the boundary.
5. **Self-test CE** — ask: "Name something relevant to this problem that doesn't fit any category." If you can, add or restructure.
6. **Check the Other bucket** — if "Other" or "Miscellaneous" captures more than ~20% of the scope, decompose it further. A fat Other means your structure is leaking.
7. **Size each bucket** — estimate rough magnitude (Large / Medium / Small impact). This drives the "where to focus" recommendation.
8. **Go deeper selectively (depth follows sizing)** — apply steps 2-7 recursively, but depth MUST vary by bucket size. L-sized buckets MUST get at least one more level of decomposition than S-sized buckets. Do not give every branch uniform depth — that signals you're filling a template, not thinking. Max 3 levels deep unless the problem demands more. Stop when sub-categories become actionable.

## Known Identity Library

Anchor on these before building custom structures. These are mathematical identities or universally accepted decompositions — not suggestions.

### Business

| Problem | MECE Identity |
|---------|---------------|
| Revenue | Volume x Price |
| Profit | Revenue - Costs |
| Costs | Fixed + Variable |
| Growth | New + Expansion - Churn |
| Traffic | Paid + Organic + Direct + Referral |
| Market | Segment A + B + C + ... + Other |
| Time | Past + Present + Future |
| Control | Things we control + Things we don't |
| Users | New + Returning + Resurrected + Contracted + Churned |
| Funnel | Awareness > Consideration > Decision > Retention |
| Risk | Probability x Impact |

### Performance / Systems

| Problem | MECE Identity |
|---------|---------------|
| Latency | Network + Compute + I/O + Queue wait |
| System failure | Hardware + Software + Configuration + External dependency |
| Capacity | CPU + Memory + Storage + Network bandwidth |

### Software Engineering

| Problem | MECE Identity |
|---------|---------------|
| Bug source | Logic + Data + Concurrency + Integration + Environment |
| Tech debt | Code + Architecture + Infrastructure + Dependencies |
| Deployment failure | Build + Test + Release + Runtime |

### Security

| Problem | MECE Identity |
|---------|---------------|
| Attack surface | Network + Application + Identity + Data + Physical |
| Incident response | Detect + Contain + Eradicate + Recover |

## Direct Invocation

When invoked via `/mece [problem]`:

- If no problem provided, ask: "What problem or question do you want to decompose?"
- Run the Protocol above
- Present output in the format below
- One-shot — produce the best breakdown with self-verification built in, don't iterate unless the user asks to refine

### Output Format

```
## MECE Breakdown: [Problem/Question]

[Problem]
├── [Category A] — [size: L/M/S]
│   ├── [Sub-category A1]
│   ├── [Sub-category A2]
│   └── [Sub-category A3]
├── [Category B] — [size: L/M/S]
│   └── ...
├── [Category C] — [size: L/M/S]
│   └── ...
└── [Category D] — [size: L/M/S]

**ME check:** [For each flagged pair, explain why they don't overlap.
              If none flagged: "No overlaps found."]
**CE check:** [What you tested for and why it's covered.
              If gap found and fixed, say so.]

**Where to focus:** [Highest-impact bucket] because [reason tied to sizing].
```

## Composability

Other skills use MECE as a thinking primitive by referencing this protocol:

> "Apply the MECE protocol to decompose [X]."

When composed into another skill's flow:
- Run the Protocol steps internally
- Embed the decomposition naturally in the parent skill's output — no separate "MECE Breakdown" header or formatted output wrapper
- The parent skill controls presentation

Example: a JTBD opportunity-scoring skill might say "Apply MECE protocol to decompose the job map into non-overlapping outcome categories." Claude runs the protocol, uses the result within the JTBD output format.

## Examples

**Why is revenue down?**

Not MECE:
- Marketing isn't working
- Sales team is weak
- Product issues
- Bad economy
(Overlaps: marketing/sales/product all affect each other. Not exhaustive: missing pricing, churn.)

MECE (anchored on Revenue = Volume x Price):
- Volume down (fewer customers) — L
  - Fewer leads
  - Lower conversion
  - Higher churn
- Price down (same customers, less revenue) — M
  - Lower prices
  - Smaller deals
  - Worse mix

**How can we grow?**

MECE (anchored on Growth = New + Expansion - Churn):
- Acquire new customers — L
- Expand existing customers — M
- Reduce churn — M

## Anti-patterns

| Anti-pattern | Signal | Fix |
|-------------|--------|-----|
| Categories overlap | "Marketing" and "Social media" at same level | Redraw boundaries — social media is a subset of marketing |
| Fat Other bucket | "Other" covers >20% | Decompose it — your structure is incomplete |
| Not exhaustive | Obvious items don't fit anywhere | Add categories or restructure |
| Too many top-level | 8+ categories at level 1 | Group into higher-level buckets first |
| Too abstract | Categories aren't measurable or actionable | Make concrete — "improve things" becomes specific levers |
| Ignored known identity | Free-formed revenue breakdown | Check the Known Identity Library first |
| Infinite recursion | 5+ levels deep | Stop — sub-categories should be actionable by level 3 |
