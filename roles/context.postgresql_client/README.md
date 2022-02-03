Postgresql Client
=================

[![Build Status](https://travis-ci.org/ome/ansible-role-postgresql-client.svg)](https://travis-ci.org/ome/ansible-role-postgresql-client)
[![Ansible Role](https://img.shields.io/ansible/role/TODO)](https://galaxy.ansible.com/context.postgresql-client/)

Install PostgreSQL clients from the upstream distribution.

If you wish to use your distributions packages do not use this role.


Role Variables
--------------

Required:
- `postgresql_version`: The PostgreSQL major version, e.g. `9.6`, `10`, `11`.

Optional:
- `postgresql_package_version`: The PostgreSQL full version, ignored on Ubuntu, e.g. `9.6.13`


Example Playbook
----------------

    # Simple example relying on the default Postgres PUBLIC privileges
    # which allow access to all users
    - hosts: localhost
      roles:
      - role: context.postgresql_client
        postgresql_version: "10"


Author Information
------------------

ome-devel@lists.openmicroscopy.org.uk
