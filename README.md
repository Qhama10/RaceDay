| **Module:** | Programming |
| --- | --- |
| **Assignment:** | RaceDay — Part 1: System Planning and Database |
| **Student Name:** | Qhama Hobongwana |
| **Student Number:** | ST10465226 |

# RaceDay — Event Management System

## System Overview

RaceDay is a web-based event management platform for South African road running, walking, and cycling events. It replaces paper-based registration and disconnected spreadsheets with a single platform where organisers can run events and participants can enter them and track their results.

The system supports two user roles, stored in two separate tables:

- **Organiser** (`Organisers` table) — creates and manages events and categories, and captures participant results.
- **Participant** (`Participants` table) — browses events, enrols in an event by selecting a category, and views their own enrolments and results.

Both roles can view and update their own profile information via a shared `/api/users/me` route; the API determines which table to read/write based on the role stored in the JWT issued at login.

Role-based access is enforced at the API level (Part 2) and reflected consistently in the MVC interface (Part 3).

## Key Features

- Secure authentication using JWT, with a `role` claim distinguishing Organisers from Participants.
- Role-based access control (Organiser vs Participant).
- Event, category, enrolment, and result management.
- Events capture a name, description, date, location, distance, and type (`Run`, `Walk`, or `Cycle`).
- A full REST API (Part 2) consumed by an MVC frontend (Part 3).

## Repository Structure

```
/docs
  README.md                  <- this file
  RaceDay_API_Endpoint_Plan.docx   <- full REST API specification
  RaceDay_Schema.sql         <- database creation + seed script (RACEDAY.SQL)
  RaceDay_ERD.pdf            <- entity relationship diagram
.github/workflows/
  validate-docs.yml          <- CI workflow validating /docs structure
```

## Setup Instructions

1. Clone the repository.
2. Open SQL Server Management Studio (SSMS) and connect to a local or remote SQL Server instance.
3. Run `docs/RaceDay_Schema.sql` to create the database and seed sample data. **Before running this on a clean instance, see "Known issues" below** — the current script will fail on a first run.
4. Update the connection string in the application settings (added in Part 2).
5. Build and run the API (Part 2) and the MVC application (Part 3).

## Database

The data model uses six entities: `Organisers`, `Participants`, `Events`, `Categories`, `Enrolments`, and `Results`. Rather than a single `Users` table with a shared `Profiles` table, Organisers and Participants are modelled as two separate tables from the start — each holding only the fields relevant to that role, so no separate profile table is needed.

## Deliberate differences between the SQL script and the ERD

Per the assignment brief, any deliberate difference between the SQL script and the ERD must be explained here rather than left unexplained.

- **`Enrolments` does not store `event_id`.** The ERD shows `event_id (FK)` on `Enrolments`, but the SQL script deliberately omits it, since a category already belongs to exactly one event (`Categories.event_id`) — storing it again on `Enrolments` would be redundant. The trade-off: enforcing "one enrolment per participant per event" (rather than per category) has to happen at the application level in Part 2, since the database can no longer express that rule as a single `UNIQUE` constraint on `Enrolments`. This is also noted in `RaceDay_API_Endpoint_Plan.docx`.
- **`Categories` includes a `category_distance` field not shown on the ERD.** This was added so each category can state its own distance (e.g. "10km", "21km") independently of the event's overall `distance` field on `Events`. The ERD should be updated to include this column before final submission.

## Known issues — fix before submission

These are not deliberate design decisions and should be corrected; they're listed here so nothing gets missed.

1. **The SQL script will fail on a clean database.** `RACEDAY.SQL` runs `DROP TABLE Results;` (and the other `DROP TABLE` statements) immediately after `CREATE DATABASE` / `USE`, with no `IF EXISTS` guard. On a brand-new database none of these tables exist yet, so the very first `DROP TABLE` statement will error and the script won't run end-to-end. Add `IF EXISTS` to each `DROP TABLE` line (e.g. `DROP TABLE IF EXISTS Results;`) so the script is safe to re-run.
2. **`Results` has two organiser-reference columns instead of one.** The table defines both `updated_by INT NOT NULL` (with no foreign key attached) and a separate `organisers_id INT FOREIGN KEY REFERENCES Organisers(organisers_id)` (nullable). The seed data only populates `updated_by`, so `organisers_id` — the one column that's actually constrained as a foreign key — is left `NULL` on every row. Pick one column: keep `updated_by` as the foreign key to `Organisers`, add `NOT NULL` and the `FOREIGN KEY` constraint to it, and remove the redundant `organisers_id` column.
3. **`Enrolments` has no uniqueness constraint.** Nothing currently stops the same participant enrolling twice in the same category. Add `CONSTRAINT UQ_Enrolment_ParticipantCategory UNIQUE (participant_id, category_id)`.
4. **Some foreign keys are nullable that shouldn't be.** `Enrolments.participant_id`, `Enrolments.category_id`, and `Categories.event_id` are declared without `NOT NULL`. Since every enrolment must belong to a participant and category, and every category must belong to an event, these should all be `NOT NULL`.
5. **Seed data inconsistency:** the "Cyclers" category on the Cape Town Cycle Tour (event 2) has `category_distance = '10km'`, but its description reads "Full cycle tour distance" and the event itself is 109km. This looks like a copy-paste value left over from the other categories — update it to `'109km'`.
6. **The API endpoint plan doesn't account for `category_distance`.** `RaceDay_API_Endpoint_Plan.docx` lists the Categories `POST`/`PUT` request body as `{ categoryName, categoryDescription }`, but the database now requires `category_distance` as `NOT NULL`. Add `categoryDistance` to both request bodies in the endpoint plan so the documented API actually matches what the database requires.
7. **The ERD PDF is out of date** in two ways covered above (still shows `event_id` on `Enrolments`; missing `category_distance` on `Categories`). Regenerate the ERD once you're happy with the final schema so it matches the SQL script exactly, as the rubric requires.

## API

See `RaceDay_API_Endpoint_Plan.docx` for the complete endpoint specification, covering authentication, user profile, events, categories, enrolments, and results. This plan will be implemented as-is in Part 2; any deviation during implementation will be explained in that part's README. (See item 6 above — the categories endpoints need a small update first.)

## CI/CD

A GitHub Actions workflow (`.github/workflows/validate-docs.yml`) validates that the `/docs` folder exists and contains the required files on every push and pull request.

**Build status:** ✅ *(insert screenshot of the green Actions run here before submission)*

<img width="671" height="633" alt="image" src="https://github.com/user-attachments/assets/c63a1026-a24c-4119-a2a9-749eda770bd2" />


## Video Presentation

`[Insert link to YouTube video here — covering ERD decisions, endpoint plan choices, and a live run of the SQL script in SSMS]`

