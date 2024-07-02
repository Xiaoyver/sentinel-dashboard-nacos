# 该镜像需要依赖的基础镜像
FROM  adoptopenjdk/openjdk11:jre11u-nightly
# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 指定维护者的名字
MAINTAINER gdLiu
# 工作目录
ENV DIRPATH /usr/local/sentinel
WORKDIR ${DIRPATH}
# 文件名
ARG JAR_FILE
# 将当前目录下的jar包复制到docker容器的/目录下
COPY ${JAR_FILE}  app.jar
# 声明服务运行在8080端口
EXPOSE 8080
# 写入运行参数
ENV JAVA_OPTS="\
-server \
-Xmx512M \
-Xms512M \
-Xmn512M \
-Xss256K" \
NACOS_SERVER_ADDR="127.0.0.1:8848" \
NACOS_NAMESPACE="public" \
NACOS_GROUP="DEFAULT_GROUP" \
NACOS_USERNAME="nacos" \
NACOS_PASSWORD="nacos"

# 运行
ENTRYPOINT java ${JAVA_OPTS} -jar ${DIRPATH}/app.jar -Dnacos.server-addr=NACOS_SERVER_ADDR -Dnacos.group-id=NACOS_GROUP -Dnacos.namespace=NACOS_NAMESPACE -Dnacos.username=NACOS_USERNAME -Dnacos.password=NACOS_PASSWORD
