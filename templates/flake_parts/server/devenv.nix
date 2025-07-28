{ pkgs, ... }:
let
  db_user = "percygt";
  db_host = "localhost";
  db_port = 5432;
  db_name = "ecom_db";
  dj_user = "admin";
  dj_email = "admin@admin.com";
  dj_pass = "admin";
  django_port = "8000";
  redis_port = "6379";
  server_dir = "server";
in
{
  languages.python-with-relative-path = {
    enable = true;
    package = pkgs.python310;
    poetry = {
      enable = true;
      install = {
        enable = true;
        directory = "server";
      };
    };
  };
  process-managers.process-compose = {
    settings = {
      processes = {
        django-setup = {
          depends_on = {
            postgres = {
              condition = "process_healthy";
            };
            redis = {
              condition = "process_healthy";
            };
          };
        };
        django-serve = {
          depends_on = {
            django-setup = {
              condition = "process_completed_successfully";
            };
          };
        };
      };
    };
  };
  services.redis.enable = true;
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    initialScript = "CREATE USER ${db_user} SUPERUSER;";
    initialDatabases = [ { name = db_name; } ];
    listen_addresses = db_host;
    port = db_port;
  };
  env = {
    DJANGO_SETTINGS_MODULE = "storefront.settings.local";
    DATABASE_URL = "postgresql://${db_user}@${db_host}:${builtins.toString db_port}/${db_name}";
    DEBUG = true;
  };

  enterShell = ''
    # If poetry environment is broken we can check this env var in CI & recache
    export POETRY_STATUS=$(check-poetry-status)
    echo "POETRY_STATUS=$POETRY_STATUS"
  '';

  processes = {
    django-setup.exec = ''
      printf "Migrating Database ...\n\n"
      migrate-db
      DJANGO_SUPERUSER_PASSWORD=${dj_pass} dj createsuperuser --noinput --first_name "${dj_user}" --last_name "${dj_user}" --email "${dj_email}"
    '';
    django-serve.exec = ''
      printf "Launching Django ...\n\n"
      dj runserver 0.0.0.0:${django_port}
    '';
  };
  scripts = {
    dj.exec = ''
      python manage.py $@
    '';
    handle_interrupt.exec = ''
      interrupt_handler() {
        kill-services
        exit 1
      }

      trap 'interrupt_handler' SIGINT
    '';
    check-poetry-status.exec = ''
      STATUS=$(poetry check -C ${server_dir})
      if [[ "$STATUS" == 'All set!' ]]; then
        echo "clean"
      else
        echo "broken"
      fi
    '';
    start-services-in-background.exec = ''
      if ! nc -z ${db_host} ${builtins.toString db_port};
      then
        printf "Starting database in background ...\n"
        nohup devenv up > /tmp/devenv.log 2>&1 &
      fi
    '';
    kill-services.exec = ''
      printf "Killing background services ...\n"
      fuser -k ${builtins.toString db_port}/tcp 2>/dev/null
      fuser -k ${django_port}/tcp 2>/dev/null
      fuser -k ${redis_port}/tcp 2>/dev/null
    '';
    wait-for-db.exec = ''
      printf "Waiting for database to start ...\n"
      printf "(if wait exceeds 100 percent then check /tmp/devenv.log for errors)\n"

      # wait up to 20s for the database to launch ...
      n_loops=20;
      timer=0;
      while true;
      do
        if nc -z ${db_host} ${builtins.toString db_port}; then
          printf "\nDatabase is running!\n\n"
          exit 0
        elif [ $timer -gt $n_loops ]; then
          printf "\nDatabase failed to launch!\n\n"
          exit 1
        else
          sleep 1
          let timer++
          percent=$((timer*100/n_loops))
          bar+="#"
          printf "\r[%-100s] %d%%" "$bar" "$percent"
        fi
      done
    '';
    launch_django.exec = ''
      interrupt_handler() {
        kill-services
        exit 1
      }

      trap 'interrupt_handler' SIGINT
      launch_django() {
        printf "Launching Django ...\n\n"
        start-services-in-background
        wait-for-db || exit 1 # if wait-for-db fails, exit!
        dj runserver ${django_port}
      }

      launch_django
    '';

    migrate-db.exec = ''
      dj makemigrations --no-input
      dj migrate --no-input
      dj collectstatic --no-input
      if [ ! -f .direnv/data_loaded ]; then
        dj loaddata store
        touch .direnv/data_loaded
      fi
    '';

    open-url.exec = ''
      gio open http://localhost:${django_port}
    '';

    clean-all.exec = ''
      kill-services
      find . \( -name __pycache__ -o -name "*.pyc" \) -delete
      rm -f */migrations/0*.py
      rm -rf .devenv/state/postgres/
      rm -rf .devenv/state/redis/
      rm -f .direnv/data_loaded
    '';
    test-all.exec = ''
      interrupt_handler() {
        kill-services
        exit 1
      }

      trap 'interrupt_handler' SIGINT

      run_tests() {
        printf "Running tests...\n\n"
        start-services-in-background
        wait-for-db || exit 1 # if wait-for-db fails, exit!
        dj collectstatic --noinput
        dj test $@
        kill-services
        exit 0
      }

      run_tests
    '';
  };
}
