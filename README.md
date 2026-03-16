# Duty Scheduler
A simple schedule creator that assigns duties for bi-weekly meetings written in vox.

## Overview
Duty Scheduler is a tool that creates rotating schedules for bi-weekly meeting duties, automatically assigning tasks to team members.

## How the Scheduler Works
The scheduler reads a list of people from `names.txt` and produces a balanced duty plan across meetings.

At a high level:
- Every meeting has a fixed set of duty slots.
- People are assigned in a rotating order (round-robin style).
- The next meeting continues from where the previous one left off.
- This keeps assignments spread out over time instead of repeatedly picking the same few people.

The result is a schedule that is:
- Predictable (easy to understand)
- Fair (rotation-based distribution)
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
After running, the program generates a compiled binary (`scheduler`) and then creates schedule output based on the names provided.

Depending on how your `scheduler.vox` is configured, output may include:
- Terminal summary output
- A CSV file for sharing or printing

## Rotation Logic (Detailed)
The core assignment strategy is circular:
1. Start from the first person in the list.
2. Fill duty slots for the current meeting from the current position.
3. Move the pointer forward after each assignment.
4. When the end of the list is reached, wrap back to the beginning.
5. Continue for each future meeting.

This approach avoids manual tracking and makes it simple to explain who is next and why.

## When to Regenerate the Schedule
Regenerate whenever:
- A person is added or removed from `names.txt`
- Meeting count or schedule period changes
- You want a fresh schedule starting from the current roster

Because generation is deterministic from your input list, you can keep scheduling consistent and transparent.

## Usage
1. Add names to `names.txt` (one per line)
2. Compile: `vox build scheduler.vox`
3. Run: `./scheduler`

## About Vox
Vox is a functional programming language designed for simplicity and expressiveness. It features:
- Strong static typing with type inference
- First-class functions and closures
- Pattern matching
- Immutable data structures by default
- Concise syntax inspired by ML-family languages
