{% set pnda_user = pillar['pnda']['user'] %}
{% set pnda_password = pillar['pnda']['password_hash'] %}
{% set pnda_group = pillar['pnda']['group'] %}
{% set pnda_home_directory = pillar['pnda']['homedir'] %}

pnda-install_selinux:
  pkg.installed:
    - pkgs:
      - policycoreutils-python
      - selinux-policy-targeted
    - onlyif:
      - ls /etc/selinux/config

permissive:
  selinux.mode:
    - onlyif:
      - ls /etc/selinux/config
  file.replace:
    - name: '/etc/selinux/config'
    - pattern: '^SELINUX=(?!\s*permissive).*'
    - repl: 'SELINUX=permissive'
    - append_if_not_found: True
    - show_changes: True
    - onlyif:
      - ls /etc/selinux/config

pnda-create_pnda_user:
  user.present:
    - name: {{ pnda_user }}
    - password: {{ pnda_password }}
    - home: {{ pnda_home_directory }}
    - createhome: True

pnda-create_pnda_group:
  group.present:
    - name: {{ pnda_group }}
    - addusers:
      - {{ pnda_user }}

pnda-set_home_dir_perms:
  file.directory:
    - name: {{ pnda_home_directory }}
    - mode: 755
