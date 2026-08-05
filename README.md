# Nexentra Solutions — Company Website

The official marketing website for **Nexentra Solutions**.
*Innovate · Integrate · Elevate*

This is a standalone project. It is **not** connected to the Logistics ERP codebase — no shared code, no API calls, no database. Everything on the page is static.

---

## Run it locally

You need nothing installed except Python (already on this machine).

```bash
python -m http.server 4321
```

Then open **http://localhost:4321**

Alternatively, with Node:

```bash
npx serve -l 4321
```

Or simply double-click `index.html` — it works straight from the filesystem too.

---

## Project structure

```
nexentra-site/
├── index.html        The entire website — HTML, CSS and JS in one file
├── favicon.svg       Browser tab icon (the Nexentra mark)
├── .claude/
│   └── launch.json   Dev server config for Claude Code's preview pane
├── .gitignore
└── README.md         You are here
```

**Why one file?** Zero dependencies, zero build step, loads instantly, and it deploys anywhere that can serve a static file. When the site grows past a few pages, this gets split up — but not before it needs to be.

---

## Brand

Taken directly from the logo.

| Token | Hex | Used for |
|---|---|---|
| Navy (deep) | `#050A18` | Page background |
| Navy | `#0A1435` | Panels, logo mark |
| Navy (mid) | `#0D1B3E` | Elevated surfaces |
| Blue (primary) | `#1560E0` | Buttons, links, accents |
| Blue (bright) | `#1B6BF0` | Gradients, glows |
| Blue (light) | `#4A9BFF` | Highlights, icons |
| Blue (pale) | `#7FBAFF` | Gradient text, small accents |

All defined as CSS custom properties at the top of `index.html` under `:root`. **Change a colour there and it updates everywhere** — nothing is hardcoded further down.

The logo is inline SVG (`<symbol id="nxMark">`), so it stays sharp at any size and is reused by reference in the header, footer and favicon.

---

## Page sections

1. **Nav** — logo, links, glass blur on scroll, mobile hamburger
2. **Hero** — word-by-word headline reveal, then the product mockup tilts up into place
3. **Tech stack marquee** — infinite scroll, pauses on hover
4. **Services** — bento grid, 6 cards with cursor-following spotlight
5. **Approach** — Innovate / Integrate / Elevate on a rail that fills as you scroll
6. **Flagship product** — Nexentra Logistics ERP with an interactive 4-role dashboard switcher
7. **Stats** — counters that animate up when scrolled into view
8. **Testimonial**
9. **CTA band**
10. **Footer**

---

## Known placeholders

Replace these before going live:

- `hello@nexentra.in` — real email address
- `+91 00000 00000` — real phone number
- Social links in the footer (`href="#"`)
- The pilot-customer testimonial — needs a real name and permission to use it
- **The dashboard mockups are fabricated.** All numbers, vehicle numbers and party names are invented for illustration. Swap in real screenshots of the ERP before showing this to customers.

---

## Deploying

Being a static site, it can go almost anywhere for free:

- **Netlify / Vercel / Cloudflare Pages** — drag the folder in, done
- **GitHub Pages** — push and enable Pages in settings
- **Any web host** — upload `index.html` and `favicon.svg` via FTP

No build command. No server runtime. No environment variables.
