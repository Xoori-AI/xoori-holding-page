# Xoori holding page

Static "we'll be back soon" site served on xoori.ai while Xoori is hibernating
(from October 2026). Hosted on GitHub Pages from the `docs/` folder.

- `_src/` — page template, styles, and the privacy / terms / SMS-consent content
  captured word for word from the live site on 2026-10-05. Twilio's toll-free
  verification was approved against that wording, so do not edit it.
- `build.ps1` — rebuilds `docs/` from `_src/`.

When Xoori comes back, point the domain back at Vercel (see the hibernation plan in
the Xoori-MVP repo, `Troubleshoot/9`) and archive this repo.
