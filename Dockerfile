FROM  mysql:5.7.42-oracle  as base
RUN curl -L https://mirrors.huaweicloud.com/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz -o /tmp/jdk-7u80-linux-x64.tar.gz
RUN tar -xf /tmp/jdk-7u80-linux-x64.tar.gz -C /usr/local

ADD UnlimitedJCEPolicy.tar /tmp
RUN mv  -f  /tmp/UnlimitedJCEPolicy/* /usr/local/jdk1.7.0_80/jre/lib/security/

RUN mkdir  /usr/local/MapleStory-Server-079
ADD bin  /usr/local/MapleStory-Server-079/bin
ADD config   /usr/local/MapleStory-Server-079/config
ADD scripts   /usr/local/MapleStory-Server-079/scripts
COPY start.sh  /usr/local/MapleStory-Server-079/
COPY ms_20210813_234816.sql  /usr/local/MapleStory-Server-079/
RUN mkdir /usr/local/MapleStory-Server-079/logs
RUN chmod -R 777  /usr/local/MapleStory-Server-079


FROM mysql:5.7.42-oracle
RUN yum install  -y  net-tools vim

ARG MYSQL_ROOT_PASSWORD
ARG IP

COPY --from=base /usr/local/jdk1.7.0_80 /usr/local/jdk1.7.0_80
COPY --from=base /usr/local/MapleStory-Server-079 /usr/local/MapleStory-Server-079

ENV JAVA_HOME /usr/local/jdk1.7.0_80
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH  .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

RUN sed '430 a         nohup sh /usr/local/MapleStory-Server-079/start.sh &' -i /usr/local/bin/docker-entrypoint.sh

