FROM apache/airflow:2.8.2


USER root
#install Java
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         openjdk-17-jre-headless \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

Run apt-get update
RUN apt-get install -y unixodbc-dev
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc


COPY set-pyspark-submit-args.sh /usr/src/app/

# Make the script executable
RUN chmod +x /usr/src/app/set-pyspark-submit-args.sh

# Run the script to set PYSPARK_SUBMIT_ARGS
RUN /usr/src/app/set-pyspark-submit-args.sh

user airflow
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
