FROM httpd

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    bash && \
    rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip 

RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    /usr/local/bin/aws --version 

RUN rm -f awscliv2.zip && rm -rf aws && \
    /usr/local/bin/aws --version

COPY ./index.html /usr/local/apache2/htdocs/

CMD ["httpd", "-D", "FOREGROUND"]
