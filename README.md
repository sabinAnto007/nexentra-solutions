# Nexentra Solutions — Company Website

The official marketing website for **Nexentra Solutions**.
*Innovate · Integrate · Elevate*

This is a standalone project. It is **not** connected to the Logistics ERP codebase — no shared code, no API calls, no database. Everything on the page is static.

---

## Run it locally

Pick whichever is convenient. All three serve the same file.

**Docker** (closest to production — this is what actually gets deployed):

```bash
docker compose up -d
```

**Python**, no install needed:

```bash
python -m http.server 4321
```

**Node**:

```bash
npx serve -l 4321
```

Then open **http://localhost:4321**. Double-clicking `index.html` works too — it runs straight from the filesystem.

---

## Docker

The image is nginx serving two static files. There is no build step to containerise, so the Dockerfile is a single stage.

| | |
|---|---|
| Base | `nginx:1.27-alpine` |
| Listens on | `8080` inside the container, published as `4321` |
| User | `nginx` — **not root** |
| Health check | `GET /healthz` every 30s |
| gzip | on — the page drops from ~170 KB to ~43 KB |

```bash
docker compose up -d            # start
docker compose ps               # check health
docker compose logs -f site     # follow nginx logs
docker compose down             # stop
docker compose up -d --build    # rebuild after editing index.html
```

### Live-edit mode

Mounts the source files read-only, so a browser refresh picks up your edits with no rebuild:

```bash
docker compose --profile dev up site-dev
```

Serves on **http://localhost:4322**.

### Caching rules

`index.html` carries all the CSS and JS inline, so it is sent `no-cache` — a cached copy would otherwise pin the whole site to an old build. The favicon and any future images get a 30-day cache.

> **nginx gotcha, if you edit `nginx.conf`:** `add_header` does not merge. A `location` block that sets *any* header silently discards every `add_header` inherited from the server block. That is why the three security headers are repeated inside each location.

---

## Project structure

```
nexentra-site/
├── index.html          The entire website — HTML, CSS and JS in one file
├── favicon.svg         Browser tab icon (the Nexentra mark)
├── Dockerfile          nginx image
├── nginx.conf          gzip, caching, security headers, /healthz
├── docker-compose.yml  Production service + a dev profile with live mounts
├── .dockerignore
├── .claude/
│   └── launch.json     Dev server config for Claude Code's preview pane
├── .gitignore
└── README.md           You are here
```

**Why one file?** Zero dependencies, zero build step, loads instantly, and it deploys anywhere that can serve a static file. When the site grows past a few pages, this gets split up — but not before it needs to be.

---

## Brand

Taken directly from the logo.

| Token | Hex | Used for |
|---|---|---|
| Navy (deep) | `#050A18` | Dark-mode background |
| Navy | `#0A1435` | Panels, logo mark |
| Navy (mid) | `#0D1B3E` | Elevated surfaces |
| Blue (primary) | `#1560E0` | Buttons, links, accents |
| Blue (bright) | `#1B6BF0` | Gradients, glows |
| Blue (light) | `#4A9BFF` | Highlights, icons |
| Blue (pale) | `#7FBAFF` | Gradient text, small accents |

All defined as CSS custom properties at the top of `index.html` under `:root`. **Change a colour there and it updates everywhere** — nothing is hardcoded further down.

The site ships **light and dark themes**. It follows the visitor's OS setting on first visit (`prefers-color-scheme`), the nav toggle overrides that, and the choice is remembered in `localStorage`. An inline boot script applies the theme before first paint so there is no flash.

The logo is inline SVG (`<symbol id="nxMark">`) drawn with `currentColor`, so it inherits whatever colour its context sets and stays legible in both themes.

Each product also carries its own accent, which washes the whole page when you switch tabs — Logistics ERP blue, Kirukals purple, Gold Loan amber.

---

## Page sections

1. **Nav** — logo, links, theme toggle, Sign-in dropdown, glass blur on scroll, mobile hamburger
2. **Hero** — word-by-word headline reveal, then a delivery-pipeline tablet tilts up into place
3. **Tech stack marquee** — infinite scroll, pauses on hover
4. **Services** — bento grid, 6 cards with cursor-following spotlight
5. **Approach** — Innovate / Integrate / Elevate
6. **Products** — three tabs (Logistics ERP, Kirukals, Gold Loan ERP) on a tablet and phone rig
7. **Engage** — five ways to work with us
8. **Stats** — odometer counters that roll when scrolled into view
9. **Contact** — validated form, plus WhatsApp / email / phone channels
10. **Footer**

A fixed rail down the left edge numbers the sections and fills as you scroll.

---

## Configuration

Near the top of the `<script>` block in `index.html`:

```javascript
const NEXENTRA = {
  whatsapp : '919840000000',              // country code + number, digits only
  phone    : '+91 98400 00000',
  email    : 'hello@nexentra.in',
  apps: {
    erp      : 'https://erp.nexentra.in/login',
    gold     : 'https://gold.nexentra.in/login',
    kirukals : 'https://kirukals.app'
  }
};
```

The contact form has no backend. It composes a WhatsApp message via a `wa.me` deep link, with `mailto:` as the fallback — so there is nothing to host and no data stored anywhere.

---

## Known placeholders

Replace these before going live:

- `hello@nexentra.in` — real email address
- `+91 98400 00000` and `919840000000` — real phone and WhatsApp numbers
- The three `apps.*` sign-in URLs
- Social links in the footer (`href="#"`)
- **`og-image.png` does not exist.** The meta tags reference `https://nexentra.in/og-image.png`, so link previews on WhatsApp and LinkedIn will come up blank until it is created.
- **The dashboard mockups are fabricated.** All numbers, vehicle numbers and party names are invented for illustration. Swap in real screenshots before showing this to customers.

---

## Deploying

Being a static site, it can go almost anywhere for free:

- **Vercel / Netlify / Cloudflare Pages** — connect the repo, no build command, output directory is the repo root
- **GitHub Pages** — enable Pages in repository settings
- **Any container host** (Fly, Railway, Cloud Run, a VPS) — use the Dockerfile
- **Any web host** — upload `index.html` and `favicon.svg` via FTP

No build command. No server runtime. No environment variables.
