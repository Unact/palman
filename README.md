# palman

Платформенно-независимое мобильное приложение торговых представителей для работы с торговыми точками

Для сборки и запуска приложения необходимо иметь в корне проекта файл .env с переменными среды:

* PALMAN_SENTRY_DSN
* PALMAN_RENEW_URL
* PALMAN_YANDEX_API_KEY

Также приложения можно запускать без .env файла, но тогда при запуске надо указывать
`--dart-define PALMAN_SENTRY_DSN=<значение> --dart-define PALMAN_RENEW_URL=<значение> --dart-define PALMAN_YANDEX_API_KEY=<значение>`
