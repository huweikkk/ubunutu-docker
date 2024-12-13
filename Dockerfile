# 使用 Ubuntu 22.04 作为基础镜像
FROM ubuntu:22.04

# 更新 APT 包索引并安装 OpenSSH 服务器和其他必要工具
RUN apt update && apt install -y openssh-server sudo

# 创建 SSH 目录
RUN mkdir /var/run/sshd

# 设置 root 用户的密码（如有需要，可以根据实际情况更改）
RUN echo 'root:rootpassword' | chpasswd

# 允许 root 登录（如果默认的 sshd_config 禁用了 root 登录）
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 禁用 PAM 限制，防止 "stdin: not a tty" 错误
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 暴露 22 端口
EXPOSE 22

# 启动 SSH 服务的命令
CMD ["/usr/sbin/sshd", "-D"]

