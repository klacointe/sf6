# SF6 move sheets

Special moves, Super Arts and combo trials for Street Fighter 6 (Classic controls), with an English and a French interface.

The site is static: no framework and no build step. Docker is all you need to run it locally.

## Repository contents

- `index.html`: the page (layout, icons, printing, language switch).
- `data/characters.json`: the character list (`id`, `name`, `kanji`, and `fav`). This is the only place where a character's name and kanji are written: they feed the tabs, the home page and the page title.
- `data/<id>.json`: one file per character (unique attacks, special moves, Super Arts, combos). Loaded only when the character is opened.
- `Dockerfile`, `.dockerignore`: nginx image that serves the site (frozen version).
- `compose.yaml`, `nginx.dev.conf`: development service, where the files are mounted and never cached.
- `.env`: Compose setting (`COMPOSE_MENU=false`) that hides the interactive menu of `docker compose up`.

The home page (address without `#`) shows the legend and what is common to all characters (Drive moves, mechanics). Each character has a direct link: `…/#akuma`, `…/#chun-li`, `…/#dee-jay`, etc. The language is changed with the FR / EN buttons or with `?lang=fr` in the address; by default it follows the browser language. Printing from the browser gives an A4 layout (the tabs are hidden).

## Run the site locally

Browsers block reading JSON files when the page is opened by double-clicking it (`file://`): the page then shows a message explaining it. The site has to be served over HTTP, which Docker does for you.

Requires Docker with the Compose plugin (`docker compose version`). Both options use `nginx:alpine`.

**For development**: the folder files are mounted into the container, so an edit to `index.html` or to `data/*.json` is visible after refreshing the browser (F5), with nothing to rebuild.

```bash
cd sf6
docker compose up
```

Then open <http://localhost:8080/>. Stop with `Ctrl+C`, then `docker compose down` to remove the container. The reload is not automatic: you have to refresh the page. `nginx.dev.conf` turns off the browser cache so that F5 always shows the latest version. The `.env` file hides the "Enable Watch" menu that `docker compose up` would otherwise show: it is not needed, since the folder is mounted and changes are already live. Remove the file if you want the menu back.

**For a frozen version**: the files are copied into the image when it is built.

```bash
cd sf6
docker build -t sf6 .
docker run --rm -p 8080:80 sf6
```

Then open <http://localhost:8080/>. After changing files, run `docker build` again.

## Add a character

1. Create `data/<id>.json`, modelled on another file: `meta` and `sources` (kept as references, not displayed), `uniques`, `specials`, `throws`, `supers`, `combos`.
2. Add `{ "id": "<id>", "name": "<Name>", "kanji": "<character>" }` to `data/characters.json`.
3. French text: every English field (`note`, `t`, `n`, `names`, `g`) can have its French version in the field of the same name with a `_fr` suffix (`note_fr`, etc.). Without a translation, the English text is shown.

### Move notation

Inputs use numpad notation: `236P` (quarter circle forward + punch), `623HP`, `j.HK` (in the air), `[4]6P` (charge back, then forward), `>` to chain inside one move, `/` for variants (one per line on screen), `[hold]` after a move for a button to hold. The full list is in the comment at the top of the script in `index.html`.

## Deploy with GitHub Pages

1. Create a repository named `sf6` on GitHub (public, to use Pages for free).
2. Push the content of the folder to it.
3. In the repository: Settings, Pages, source "Deploy from a branch", branch `main`, folder `/ (root)`.
4. After a minute or two, the page is live at `https://<account>.github.io/sf6/`.

The Docker image is only for running the site locally or on your own server: GitHub Pages does not need it.

## Disclaimers

- The data for characters other than Akuma comes from online articles and has not been confirmed in the game: the sources are listed in the `sources` field of each data file (not displayed on the page).
- The button icons were redrawn from game screenshots.
- Street Fighter is a Capcom trademark: this is a fan project with no link to the publisher.
