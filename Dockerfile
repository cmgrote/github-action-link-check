# SPDX-License-Identifier: Apache-2.0

FROM alpine:latest

ENV VERSION ${VERSION:-"3.8.1"}
ENV CONFIG_FILE ${CONFIG_FILE:-".github/workflows-config/link-check-action.json"}

LABEL "com.github.actions.name"="link-check-action"
LABEL "com.github.actions.description"="Check links in a project's Markdown files."
LABEL "com.github.actions.icon"="link"
LABEL "com.github.actions.color"="blue"
LABEL "repository"="https://github.com/cmgrote/link-check-action.git"
LABEL "homepage"="https://github.com/cmgrote/link-check-action"
LABEL maintainer="cmgrote <chris@thegrotes.net>"

RUN apk --no-cache add bash nodejs npm && \
	apk --no-cache add -X http://dl-cdn.alpinelinux.org/alpine/edge/community fd && \
	npm --no-cache install markdown-link-check@${VERSION}

COPY entrypoint.sh entrypoint.sh
COPY link-check-action link-check-action

ENTRYPOINT ["/entrypoint.sh"]
