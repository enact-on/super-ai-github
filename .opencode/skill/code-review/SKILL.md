---
name: code-review
description: Automated code review for pull requests using multiple specialized agents with confidence-based scoring to filter false positives
license: MIT
compatibility: opencode
---

# Code Review Skill

Automated code review patterns for pull requests with confidence-based scoring to minimize false positives.

## What I Do

I review pull requests by examining:
- **Code Quality** - Readability, maintainability, consistency
- **Potential Bugs** - Edge cases, null checks, error handling
- **Performance** - Inefficient algorithms, unnecessary computations
- **Type Safety** - Missing types, incorrect type usage
- **Best Practices** - Language and framework conventions
- **Testing Coverage** - Missing test cases, untested code paths

## Review Process

1. **Understand Context** - What changes were made and why?
2. **Check Patterns** - Are established patterns being followed?
3. **Identify Issues** - List problems with severity levels
4. **Suggest Improvements** - Provide actionable recommendations
5. **Prioritize** - Flag critical vs. nice-to-have issues

## Output Format

Group findings by severity:
- **Critical** - Bugs, security issues, major design flaws
- **Important** - Performance issues, anti-patterns
- **Suggestion** - Style, naming, minor improvements

## Confidence-Based Filtering

Not every issue needs to be reported. Filter out:
- Stylistic preferences that don't affect functionality
- Minor optimizations with negligible impact
- Personal preferences that follow established patterns

## When in Doubt

- Ask the user for their preference
- Check the project's existing patterns
- Err on the side of not reporting marginal issues

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
