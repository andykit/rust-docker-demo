# # select build image
# FROM rust:1.23 as build

# # create a new empty shell project
# RUN USER=root cargo new --bin my_project
# WORKDIR /my_project

# # copy over your manifests
# COPY ./Cargo.lock ./Cargo.lock
# COPY ./Cargo.toml ./Cargo.toml

# # this build step will cache your dependencies
# RUN cargo build --release
# RUN rm src/*.rs

# # copy your source tree
# COPY ./src ./src

# # build for release
# RUN rm ./target/release/deps/my_project*
# RUN cargo build --release

# # our final base
# FROM debian:jessie-slim

# # copy the build artifact from the build stage
# COPY --from=build /my_project/target/release/my_project .

# # set the startup command to run your binary
# CMD ["./my_project"]

#
# 使用MultiStage构建和发布Docker镜像
#

#
# 构建编译器镜像，建议使用Rust最新版
#
FROM rust as builder

WORKDIR /usr/src/app

COPY . .

RUN RUSTFLAGS="-C target-cpu=native" cargo build --release

#
# 构建应用发布镜像，构建出的镜像体积最小
#
FROM debian:jessie-slim

COPY --from=builder /usr/src/app/target/release/server /app

EXPOSE 3000
CMD ["/app"]