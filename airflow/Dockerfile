FROM apache/airflow:slim-2.10.3-python3.10

RUN pip install --no-cache-dir \
    apache-airflow-providers-postgres \
    apache-airflow-providers-oracle[common.sql] \
    apache-airflow-providers-microsoft-mssql[common.sql] \
    apache-airflow-providers-elasticsearch[common.sql]
