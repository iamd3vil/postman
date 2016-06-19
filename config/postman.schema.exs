@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "postman.adapter": [
      commented: false,
      datatype: :atom,
      default: :local,
      doc: "Adapter for postman. Can be `local` or `mailgun` or `sendgrid` or `mandrill` or `smtp`",
      hidden: false,
      to: "postman.adapter"
    ],
    "postman.Elixir.Postman.Mailer.api_key": [
      commented: false,
      datatype: :binary,
      default: "API_KEY",
      doc: "Mailgun API KEY",
      hidden: false,
      to: "postman.Elixir.Postman.Mailer.api_key"
    ],
    "postman.smtp_username": [
      commented: false,
      datatype: :binary,
      default: "Your smtp username",
      doc: "SMTP username",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.username"
    ],
    "postman.smtp_password": [
      commented: true,
      datatype: :binary,
      default: "",
      doc: "SMTP password",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.password"
    ],
    "postman.smtp_port": [
      commented: true,
      datatype: :integer,
      default: 1025,
      doc: "SMTP server port",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.port"
    ],
    "postman.smtp_server": [
      commented: true,
      datatype: :binary,
      default: "smtp.domain",
      doc: "SMTP server",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.server"
    ],
    "postman.smtp_tls": [
      commented: true,
      datatype: :atom,
      default: :if_available,
      doc: "SMTP TLS settings. Can be `if_available` or `always` or `never`",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.tls"
    ],
    "postman.smtp_ssl": [
      commented: true,
      datatype: :atom,
      default: :true,
      doc: "SMTP SSL settings. Can be `true` or `false`",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.ssl"
    ],
    "postman.smtp_retries": [
      commented: true,
      datatype: :integer,
      default: 1,
      doc: "Number of retries postman can do if it fails to send the email through SMTP",
      hidden: true,
      to: "postman.Elixir.Postman.Mailer.retries"
    ],
    "postman.domain": [
      commented: false,
      datatype: :binary,
      default: "YOUR_DOMAIN",
      doc: "Domain",
      hidden: false,
      to: "postman.Elixir.Postman.Mailer.domain"
    ],
    "postman.from_addr": [
      commented: false,
      datatype: :binary,
      default: "info@skorpion.tech",
      doc: "The from address the mail has to go from",
      hidden: false,
      to: "postman.from_addr"
    ],
    "postman.port": [
      commented: false,
      datatype: :integer,
      default: 9090,
      doc: "Port for the Postman to bind.",
      hidden: false,
      to: "postman.port"
    ],
    "postman.purpose": [
      commented: false,
      datatype: :atom,
      default: :email,
      doc: "Write the purpose of using Postman. For Example `email`",
      hidden: false,
      to: "postman.purpose"
    ],
    "postman.interaction": [
      commented: false,
      datatype: [list: :binary],
      default: ["api", "rabbitmq"],
      doc: "How would you interact with postman. For eg: api or rabbitmq",
      hidden: false,
      to: "postman.interaction"
    ],
    "postman.rabbitmq_username": [
      commented: false,
      datatype: :binary,
      default: "guest",
      doc: "Rabbitmq Username",
      hidden: false,
      to: "postman.rabbitmq_username"
    ],
    "postman.rabbitmq_password": [
      commented: false,
      datatype: :binary,
      default: "guest",
      doc: "Rabbitmq password",
      hidden: false,
      to: "postman.rabbitmq_password"
    ],
    "postman.rabbitmq_host": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc: "Rabbitmq Host",
      hidden: false,
      to: "postman.rabbitmq_host"
    ],
    "postman.rabbitmq_port": [
      commented: false,
      datatype: :integer,
      default: 5672,
      doc: "Rabbitmq port",
      hidden: false,
      to: "postman.rabbitmq_port"
    ]
  ],
  transforms: [
    "postman.Elixir.Postman.Mailer.adapter": fn conf ->
      [{_, adapter}] = Conform.Conf.get(conf, "postman.adapter")
      case adapter do
        :mailgun -> Bamboo.MailgunAdapter
        :sendgrid -> Bamboo.SendgridAdapter
        :local -> Bamboo.LocalAdapter
        :smtp -> Bamboo.SMTPAdapter
      end
    end
  ],
  validators: []
]
