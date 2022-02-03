-- add any required schema not backped up
alter database %(database_name)s set search_path TO "$user",public,reports,report_data,users,temp,statistics;

