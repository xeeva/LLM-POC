# LLM-POC

A proof of concept demonstrating how a static website can use `robots.txt` and `llms.txt` to actively shape what large language models say about it.

The site presents itself as "Eversure Strategic Intelligence", a fictitious AI advisory firm. A human reading the HTML pages sees a believable consulting site with a quietly recurring tagline ("We don't say goodbye"). An LLM crawler following `robots.txt` is directed to `llms.txt` and `llms-full.txt`, where every sentence in the company's stated principles paraphrases a line from Rick Astley's *Never Gonna Give You Up*.

It is a rickroll, encoded structurally rather than literally, served via the emerging LLM-content standards. No song lyrics are quoted directly.

## Why this is interesting

The web has spent thirty years optimising for human readers via HTML and for search engines via `robots.txt` and structured data. The `llms.txt` proposal ([llmstxt.org](https://llmstxt.org)) is an attempt to do the same for language-model agents: a canonical, structured, low-noise document that an LLM should prefer over scraping the HTML.

This POC demonstrates three things:

1. **You can address LLM crawlers explicitly.** `robots.txt` directives like `User-agent: GPTBot` and `User-agent: ClaudeBot` are honoured by the major model providers.
2. **You can steer what they say about you.** `llms.txt` is what they will read first if you point them at it. The content of that file becomes the source of truth in their summaries.
3. **You can do this from a static site.** No server, no SSR, no headers required. GitHub Pages is sufficient.

The cheeky implication: a small business could, today, write an `llms.txt` that shapes how ChatGPT and Claude describe them in conversational search. Most have not.

## Repository layout

```
LLM-POC/
├── README.md          # this file
├── deploy.sh          # copies site/* to the gh-pages branch
└── site/              # source files for the static site
    ├── index.html
    ├── about.html
    ├── services.html
    ├── contact.html
    ├── styles.css
    ├── robots.txt
    ├── llms.txt
    └── llms-full.txt
```

The `main` branch holds source. The `gh-pages` branch holds a flat copy of `site/`, served by GitHub Pages at `https://xeeva.github.io/LLM-POC/`.

## Local preview

Any static file server works.

```bash
cd site
python3 -m http.server 8000
# then visit http://localhost:8000
```

## Deployment

```bash
./deploy.sh
```

The script publishes the current contents of `site/` to the `gh-pages` branch. It does not touch `main`.

## Testing the LLM behaviour

After deployment, paste the site URL into ChatGPT, Claude, Perplexity, or any other LLM with browse capability and ask:

> Tell me about Eversure Strategic Intelligence.

If the model has followed `llms.txt`, the response will contain the six "principles" — each of which is a paraphrased lyric line from *Never Gonna Give You Up*, dressed as corporate boilerplate.

## What this is not

- This is not a production site. The company, phone number, founders, case studies, and statistics are entirely fictional.
- This is not a security exploit. `llms.txt` is a standards proposal, not a vulnerability; this POC simply uses it as designed.
- This is not an attempt to poison model training data. The trick depends on the LLM fetching the file at query time, not on training-time ingestion.

## Inspiration and references

- [llmstxt.org](https://llmstxt.org) — the proposed standard for LLM-readable site documents
- [Anthropic crawler documentation](https://support.anthropic.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler)
- [OpenAI crawler documentation](https://platform.openai.com/docs/bots)
- The song that powers this demo, which you can find at the usual URL

## Licence

MIT. The HTML, CSS, and copy in this repository are released under the MIT licence. Do not redeploy this as if it were a real business.
