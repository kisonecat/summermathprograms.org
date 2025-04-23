# Online Hub for Summer Math Programs

Welcome to the repository for the **Summer Mathematics Programs Consortium** Online Hub! This static site is a centralized resource for middle and high school students, parents, educators, donors, and program administrators interested in summer math programs.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Content Management](#content-management)
- [Technical Infrastructure](#technical-infrastructure)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Deployment](#deployment)
- [Accessibility & SEO](#accessibility--seo)
- [Project Timeline](#project-timeline)
- [Proposal Contacts](#proposal-contacts)

---

## Project Overview

- **Repository Owner:** Summer Mathematics Programs Consortium
- **Committee Chairperson:** Jim Fowler (<fowler@rossprogram.org>)
- **RFP Issued:** December 9, 2024
- **MVP Launch Target:** October 2025

The goal of this project is to design and build a public-facing, static website that:

- Showcases profiles of summer math programs
- Provides search and filtering capabilities
- Hosts blog-style updates and static informational pages
- Is engaging, accessible (WCAG 2.1 compliant), and easy to maintain via GitHub

---

## Features

1. **Program Profiles**  
   - Markdown files with YAML front matter
   - Evergreen and year-specific data

2. **Search & Filtering Tool**  
   - Filter by age, location, eligibility, financial aid, duration, etc.
   - Multiple views: tiles, lists, and map-based

3. **Static & Blog Content**  
   - Templates for "About", "Why Summer Math Programs?", etc.
   - Blog section for updates and alumni stories (HTML & images only)

4. **Accessibility & SEO**  
   - WCAG 2.1 compliance
   - MathJax support for TeX equations with ARIA roles
   - Metadata and best practices for search engines

5. **Analytics**  
   - Track user engagement and conversion metrics

---

## Content Management

- **Source of Truth:** GitHub repository (Markdown + YAML)
- **Front Matter:** Define program fields (name, location, dates, eligibility, financial aid, etc.)
- **Editing Workflow:**  
  1. Program administrators open a Pull Request with updates
  2. Consortium reviews and merges or requests changes

---

## Technical Infrastructure

- **Build Tool:** Static site generator (e.g., Hakyll, Hugo, or similar)
- **CI/CD:** GitHub Actions for build and deploy
- **Hosting:** GitHub Pages or equivalent static host
- **Dependencies:**  
  - MathJax for math rendering  
  - Responsive CSS framework  
  - Map library (if using map-based filtering)

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/summermathprograms/online-hub.git
   cd online-hub
   ```

2. **Install dependencies**  
   _(Adjust based on chosen SSG/toolchain)_
   ```bash
   npm install
   # or
   brew install haskell-stack # if using Hakyll
   ```

3. **Run locally**
   ```bash
   npm run dev
   # or
   stack exec site watch # for Hakyll
   ```

---

## Deployment

Automated via GitHub Actions on push to `main`:

1. Install dependencies
2. Build static site
3. Deploy to GitHub Pages (or configured host)

---

## Project Timeline

| Milestone                                | Target Date       |
|------------------------------------------|-------------------|
| Design & functionality prototype         | May 2025          |
| Complete program profiles & content      | July 2025         |
| Testing & deployment preparation         | August 2025       |
| Public MVP launch                        | September 2025    |
