#FROM openjdk:8-jre-slim
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/openjdk:8-jre-slim

ARG SENTINEL_VERSION=1.8.8

# copy sentinel jar
COPY ./target/sentinel-dashboard.jar  /home/sentinel-dashboard.jar

# 设置环境变量，支持通过Docker运行时传入Nacos配置
# 分别设置每个环境变量的默认值
ENV SERVER_PORT=8080
ENV NACOS_SERVER_ADDR=localhost:8848
ENV NACOS_NAMESPACE=public
ENV NACOS_USERNAME=nacos
ENV NACOS_PASSWORD=nacos

RUN chmod -R +x /home/sentinel-dashboard.jar

EXPOSE ${SERVER_PORT}

# 在CMD中直接使用环境变量，不使用嵌套的shell变量替换语法
CMD java -Dserver.port=${SERVER_PORT} \
         -Dcsp.sentinel.dashboard.server=localhost:${SERVER_PORT} \
         -DNACOS_SERVER_ADDR=${NACOS_SERVER_ADDR} \
         -DNACOS_NAMESPACE=${NACOS_NAMESPACE} \
         -DNACOS_USERNAME=${NACOS_USERNAME} \
         -DNACOS_PASSWORD=${NACOS_PASSWORD} \
         -jar /home/sentinel-dashboard.jar
