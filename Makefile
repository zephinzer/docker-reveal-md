HOST=0.0.0.0
PORT=12345

# starts the reveal server
# * for use inside image only
start:
	@npx reveal-md ./src/index.md \
		--css ./src/assets/css/*.css \
		--scripts ./src/assets/js/*.js \
		--disable-auto-open \
		--host $(HOST) \
		--port $(PORT) \
		--watch

# build a provided theme at /reveal/css/theme/source/*.scss
# * for use inside image only
build_theme:
	@cd /reveal && npm run build -- css-themes


# - - - - - - - - - - - - - - - - - - - - - -
# below for development use only
# - - - - - - - - - - - - - - - - - - - - - -


# starts the production image
.start: .build
	@docker run \
		-it \
		--volume "$$(pwd)/src:/app/src" \
		--publish $(PORT):$(PORT) \
		zephinzer/reveal-md:latest

# builds all custom themes in ~/themes
.build_theme: .build_dev
	@touch $$(pwd)/src/theme.css
	@if ! [ -f "$$(pwd)/src/theme.scss" ]; then \
		printf -- "\n\033[31m'$$(pwd)/src/theme.scss' does not exist.\033[0m\n\n"; \
		exit 1; \
	fi
	@docker run \
		-it \
		--volume "$$(pwd)/src/theme.scss:/reveal/css/theme/source/theme.scss" \
		--volume "$$(pwd)/src/theme.css:/reveal/css/theme/theme.css" \
		--publish $(PORT):$(PORT) \
		zephinzer/reveal-md:latest-dev \
		build_theme

# builds the production image
.build:
	@docker build \
		--target production \
		--tag zephinzer/reveal-md:latest \
		.

# builds the development image
.build_dev:
	@docker build \
		--target development \
		--tag zephinzer/reveal-md:latest-dev \
		.

.publish_image: .build .build_dev
	@docker tag \
		zephinzer/reveal-md:latest zephinzer/reveal-md:$$(./node_modules/.bin/reveal-md --version)
	@docker push zephinzer/reveal-md:latest
	@docker push zephinzer/reveal-md:$$(./node_modules/.bin/reveal-md --version)
	@docker tag \
		zephinzer/reveal-md:latest-dev zephinzer/reveal-md:$$(./node_modules/.bin/reveal-md --version)-dev
	@docker push zephinzer/reveal-md:latest-dev
	@docker push zephinzer/reveal-md:$$(./node_modules/.bin/reveal-md --version)-dev
