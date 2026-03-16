# Duty Scheduler
A simple schedule creator that assigns duties for bi-weekly meetings written in vox.

## Overview
Duty Scheduler is a tool that creates rotating schedules for bi-weekly meeting duties, automatically assigning tasks to team members.

## How the Scheduler Works
The scheduler reads a list of people from `names.txt` and produces a balanced duty plan across meetings.

At a high level:
- Every meeting has a fixed set of duty slots (Door and Auditorium).
- People are selected with circular rotation, but only from those available for that meeting.
- Midweek and weekend use separate rotation counters, so missing one type does not consume your place in the other.
- A per-person assignment cap is enforced to avoid over-assigning the same few people.

The result is a schedule that is:
- Predictable (easy to understand)
- Fair (rotation + availability + assignment-cap distribution)
- Fast to regenerate whenever your team changes

## Input
The scheduler currently expects:
- `names.txt`: one name per line, in the order you want the rotation to follow.

Example:
```txt
Alice
Bob
Charlie
Dana
```

## Output
After running, the program generates a schedule assigning duties to people for bi-weekly meetings.

Depending on how your `scheduler.vox` is configured, output may include:
- Terminal summary output
- A CSV file for sharing or printing

## Rotation Logic (Detailed)
The core assignment strategy is circular with constraints:
1. For each slot, start probing from the current counter position (midweek counter for midweek, weekend counter for weekend).
2. Walk forward in circular order until finding someone who is available and still below the assignment cap.
3. Reuse the same probe for Door then Auditorium in the same meeting to avoid assigning the same person twice.
4. Advance the relevant counter after each slot so rotation continues over time.
5. Wrap naturally at the end of the list.

## When to Regenerate the Schedule
Regenerate whenever:
- A person is added or removed from `names.txt`
- Meeting count or schedule period changes
- You want a fresh schedule starting from the current roster

Because generation is deterministic from your input list, you can keep scheduling consistent and transparent.

## Prerequisites
- [Vox](https://github.com/wiki/vox-lang/vox) programming language must be installed on your system.

## Usage
1. Add names to `names.txt` (one per line)
2. Compile: `vox build scheduler.vox`
3. Run: `./scheduler`

