FROM rust:1.93.1-trixie as builder
WORKDIR /usr/src
RUN cargo new --bin changestream-to-redis
COPY Cargo.toml Cargo.lock /usr/src/changestream-to-redis/
WORKDIR /usr/src/changestream-to-redis
RUN cargo build --release
COPY src /usr/src/changestream-to-redis/src
RUN touch /usr/src/changestream-to-redis/src/main.rs
RUN cargo build --release

FROM debian:trixie
RUN groupadd --system --gid 10001 app \
 && useradd --system --uid 10001 --gid 10001 --no-create-home --shell /usr/sbin/nologin app
COPY --from=builder /usr/src/changestream-to-redis/target/release/changestream-to-redis /changestream-to-redis
USER 10001:10001
CMD ["/changestream-to-redis"]
