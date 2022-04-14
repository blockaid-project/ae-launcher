FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base python3-pip libcairo2-dev texlive ssh rsync

WORKDIR /app
COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN Rscript -e "install.packages(c('argparse', 'tidyr', 'dplyr', 'ggplot2', 'tikzDevice'))"

COPY . .

EXPOSE 8000

CMD ["/bin/bash"]
