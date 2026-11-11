# PureBasic compiler image for console programs. See readme.md.

ARG BASE_IMAGE=debian:trixie-slim

# Stage 1: extract and patch PureBasic.
FROM ${BASE_IMAGE} AS extract

RUN apt-get update \
	&& apt-get install -y --no-install-recommends binutils \
	&& rm -rf /var/lib/apt/lists/*

# Path inside Archives/, e.g. 6.41/PureBasic_Linux3_X64_6.41.tgz.
# ADD extracts it to /opt/purebasic.
ARG PUREBASIC_ARCHIVE
ADD Archives/${PUREBASIC_ARCHIVE} /opt/

# Some releases link systembase.a (which has __wrap_memcpy) before
# libpbmimalloc.a (which needs it), so builds without the debugger fail.
# Copying Memcpy.o into libpbmimalloc.a fixes it. Skipped when not needed.
ARG PUREBASIC_FIX_MEMCPY=1
RUN set -e; \
	lib=/opt/purebasic/purelibraries/linux/libraries/libpbmimalloc.a; \
	base=/opt/purebasic/compilers/systembase.a; \
	if [ "$PUREBASIC_FIX_MEMCPY" = "1" ] \
		&& ar t "$base" | grep -qx 'Memcpy.o' \
		&& ! nm "$lib" | grep -q ' T __wrap_memcpy$'; then \
		cd /tmp && ar x "$base" Memcpy.o && ar r "$lib" Memcpy.o && rm Memcpy.o; \
		echo "Patched libpbmimalloc.a with __wrap_memcpy"; \
	fi

# Stage 2: final image.
FROM ${BASE_IMAGE}

# gcc links programs and is the C backend, libssl-dev is for the Network library.
RUN apt-get update \
	&& apt-get install -y --no-install-recommends gcc libc6-dev libssl-dev \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=extract /opt/purebasic /opt/purebasic

ENV PUREBASIC_HOME=/opt/purebasic
ENV PATH=/opt/purebasic/compilers:$PATH
