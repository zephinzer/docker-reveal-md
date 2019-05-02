# `docker-reveal-md``
A Docker image for using [`reveal-md`](https://github.com/webpro/reveal-md) without installing it.

Docker image: https://hub.docker.com/r/zephinzer/reveal-md

# Usage
## Basic Usage
Create a directory with an `index.md` in it containing your slides. Then run:

```sh
docker run -it \
  --volume "$(pwd):/app/src" \
  --publish 12345:12345 \
  zephinzer/reveal-md:latest
```

To use as an alias:

```sh
alias revealmd='docker run -it -v "$(pwd):/app/src" -p 12345:12345 zephinzer/reveal-md:latest';
```


## Configuration
One downside of using a Docker image is that you lose the functionality to [use a `reveal-md.json` to configure your slides](https://github.com/webpro/reveal-md#reveal-md-options). However, you can still do this using [the YAML Front Matter annotation](https://github.com/webpro/reveal-md#yaml-front-matter) so that your file looks like:

```md
---
title: Some title
separator: <!-- s -->
verticalSeparator: <!-- v -->
revealOptions:
  transition: 'slide'
  center: false
---
# My first slide

...
```

### Custom Theme
To create a custom theme, copy one of the existing themes over from [Reveal's repository at `/css/themes/source`](https://github.com/hakimel/reveal.js/tree/master/css/theme/source) into `./src/theme.scss`.

To build the theme, run:

```sh
docker run \
		-it \
		--volume "$(pwd)/src/theme.scss:/reveal/css/theme/source/theme.scss" \
		--volume "$(pwd)/src/theme.css:/reveal/css/theme/theme.css" \
		--publish 12345:12345 \
		zephinzer/reveal-md:latest-dev \
		build_theme
```

A file at `./src/theme.css` should be create which you can use in your Front Matter YAML:

```markdown
---
# ...
theme: './src/theme.css'
# ...
---
# My first slide

...
```

# Development
Testing scripts are stored in `./Makefile`. Scripts meant for local development of the image are prefixed with a period. It follows that scripts meant for use in the image are not prefixed.

# License
This project is licensed under the MIT license. See [the LICENSE file](./LICENSE) for the full text.
