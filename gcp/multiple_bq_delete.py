from google.cloud import bigquery
import time
# import configparser


def main():
    config_parser = configparser.ConfigParser()
    config_file_path = "<your config file path>"
    config_parser.read(config_file_path)

    client = bigquery.Client.from_service_account_json(config_parser["<your config section>"]["<your config option>"])

    # first delete job
    job_config = bigquery.QueryJobConfig()

    query_job = client.query(
        ("<sql delete statement>"),
        location='<dataset location>',
        job_config=job_config)  # API request

    query_job = client.get_job(
        query_job.job_id, location="<dataset location>")  # API request - fetches job
    print('Job {} is currently in state {}'.format(
        query_job.job_id, query_job.state))
    time.sleep(2)
    query_job = client.get_job(
        query_job.job_id, location="<dataset location>")  # API request - fetches job
    print('Job {} is currently in state {}'.format(
        query_job.job_id, query_job.state))

    # second delete job
    job_config = bigquery.QueryJobConfig()

    query_job_2 = client.query(
        ("sql delete statement"),
        location='<dataset location>',
        job_config=job_config)  # API request

    query_job_2 = client.get_job(
        query_job_2.job_id, location="<dataset location>")  # API request - fetches job
    print('Job {} is currently in state {}'.format(
        query_job_2.job_id, query_job_2.state))
    time.sleep(2)
    query_job_2 = client.get_job(
        query_job_2.job_id, location="<dataset location>")  # API request - fetches job
    print('Job {} is currently in state {}'.format(
        query_job_2.job_id, query_job_2.state))


if __name__ == '__main__':
    main()
