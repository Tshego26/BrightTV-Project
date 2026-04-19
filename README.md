# 📺 BrightTV Viewership Analytics Dashboard — Q1 2016

## Project Overview

This project is an end-to-end data analytics case study built on a fictional media company, **BrightTV**, operating in South Africa. The goal was to analyse viewership patterns across Q1 2016 and surface actionable insights for executive decision-making.

The project follows a full analytics workflow — from raw data inspection and SQL querying in Databricks, through pivot table analysis in Excel, to an interactive dashboard built in Looker Studio and a CEO-level PowerPoint presentation.

---

## Business Questions Answered

Using a **5 W's framework**, the analysis answered the following:

| Framework | Question | Focus Area |
|-----------|----------|------------|
| **WHO** | Who is watching? | Race, Gender, Age Group |
| **WHAT** | What are they watching? | Channel performance, Avg viewing duration |
| **WHEN** | When are they watching? | Month, Day of Week, Time Slot |
| **WHERE** | Where are they watching from? | Province volume and engagement |
| **HOW LONG** | How engaged are they? | Viewership Engagement categories |

---

## Dataset

Two raw tables were provided:

- **UserProfile** — demographic data (Race, Gender, Age, Province)
- **Viewership** — viewing events (Channel, Duration, RecordDate, UserID)

**Raw records:** 10,000 viewership events
**After cleaning and joining:** 9,515 valid records (485 records removed due to mismatched UserIDs)

### Why were 485 records dropped?

The **Viewership** table contained two UserID columns — `UserID` and `userid` — which should have held identical values on every row. However, 485 rows had **different values** between the two columns on the same viewing record.

The reasons for this kind of mismatch can be many:
- A system error during data capture or logging
- Poor database design — having two columns serving the same purpose is a design flaw with no enforced consistency
- A data migration or ETL issue where one column was updated and the other was not

In a real-world scenario, the right step would be to go back to the data source and ask for clarification on why the two UserID columns differ on the same record. However, since no direct data source was available for this project, a deliberate decision was made to drop all 485 mismatched rows in the interest of **data integrity**.

> *"It is always better to have a smaller dataset that tells the truth than a large dataset that tells the wrong story. Since both columns matched perfectly with the User Profiles table individually, it was impossible to determine which one was correct on the 485 mismatched rows — and assuming either could be wrong, all unmatched rows were removed rather than risk introducing inaccurate data into the analysis."*

---

## Tools Used

| Tool | Purpose |
|------|---------|
| **Miro** | Project planning, 5 W's framework, brainstorming |
| **SQL (Databricks)** | Data exploration, cleaning, and transformation |
| **Excel** | Pivot tables and exploratory analysis |
| **Looker Studio** | Interactive dashboard |

---

## Methodology

### Phase 1 — Inspection
- Loaded both tables in Databricks
- Answered the anchor question: *"What does one row represent?"*
- Explored column data types, nulls, and distinct values
- Identified 485 mismatched UserIDs in the Viewership table

### Phase 2 — Planning & Brainstorming
- Mapped business questions to the 5 W's framework in Miro
- Defined data cleaning rules (age boundaries 13–90, time zone correction +2hrs SAST, engagement category thresholds)
- Planned all pivot tables before writing the big query

### Phase 3 — SQL Transformation
- Wrote individual small queries to validate each metric
- Built one combined big SELECT query for the final clean export
- Applied CASE statements for Age Group, Viewership Engagement, and Daily Hours
- Used DATEADD to convert UTC timestamps to South African Standard Time (SAST)

### Phase 4 — Excel Analysis
- Built 11 pivot tables covering all 5 W's
- Verified all Grand Totals against SQL mini queries (9,515)

### Phase 5 — Dashboard & Presentation
- Built interactive dashboard in Looker Studio
- Created 12-slide CEO-level PowerPoint presentation with insights and recommendations

---

## Key Insights

- **Sports drives everything** — SuperSport Live Events and ICC Cricket together account for 31% of all views. March viewership spiked 115% from January, fuelled by ICC Cricket coverage.
- **Gender skew is extreme** — 88% of viewers are male. Female viewership (924 views) is critically low, signalling a content gap.
- **Volume ≠ Engagement** — Gauteng leads with 36.5% of total views but ranks 6th in average viewing duration. Free State viewers watch the longest at 10.7 minutes per session.
- **Most viewers are casual** — 61.1% fall under Casual Commitment (1 min–1 hour). Only 3 viewers achieved Solid Commitment (4+ hours).
- **Afternoon is prime time** — 37% of all views occur between 12pm and 5pm. Friday is the peak day (1,590 views) and Monday is the lowest (921 views).
- **Indian Asian viewers over-index** — They represent 15% of viewership despite making up approximately 2.5% of South Africa's population.

---

## Viewership Engagement Definitions

| Category | Duration |
|----------|----------|
| Clicked and Left | 0 – 2 seconds |
| Clicked and Not Committed | 3 seconds – 1 minute |
| Casual Commitment | 1 minute – 1 hour |
| Valid Commitment | 1 – 4 hours |
| Solid Commitment | More than 4 hours |

---

## Age Group Definitions

| Category | Age Range |
|----------|-----------|
| Teenagers | 13 – 19 |
| Young Adults | 20 – 35 |
| Middle Aged | 36 – 64 |
| Senior Citizens | 65 and above |
| Invalid Age | Outside 13 – 90 or missing |

---
## Daily Hours (Time Slot) Definitions

| Category | Time Range |
|----------|-----------|
| Midnight to Early Morning | 12am – 5am |
| Morning to Late Morning | 6am – 11am |
| Early Afternoon to Late Afternoon | 12pm – 5pm |
| Early Evening to Late Evening | 6pm – 8pm |
| Night | 9pm – 11pm |

---

## Author

**Tshegofatso L. Senona**
Data Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/tshegofatso-l-senona-946a69237)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?style=flat&logo=github)](https://github.com/tshego-analyst)
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-purple?style=flat)](https://tshego-analyst.github.io)
