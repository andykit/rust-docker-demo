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
FROM busybox

COPY --from=builder /usr/src/app/target/release/server /app

EXPOSE 3000
CMD ["/app"]