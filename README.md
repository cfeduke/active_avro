# ActiveAvro
ActiveAvro is a gem used for automatically deriving the [Avro](http://avro.apache.org/docs/current/spec.html#Enums)
schemas for subclasses of ActiveRecord::Base in a non-trivial way.  When using the Avro RPC protocol one can
write serialization schemas for each type individually and then embed type references in other types by using
only the type's name.  However when using just Avro schemas only a single root type may be defined so all embedded
complex types must include their definitions (i.e. if a Person has many Pets a Pet record type definition embedded
within the Person record type definition is required).

ActiveAvro requires Rails 3.x or later.

## Getting Started

In your Gemfile:

    gem active_avro, :git => "git://github.com/cfeduke/active_avro.git"

ActiveAvro includes a Rails generator which can be used to visually verify the schema that will be generated for
your types.

    rails generate active_avro:schema Person

(Where `Person` is one of your models.)

## Configuration

ActiveAvro derives its configuration from two files in your Rails application's `/config` directory:

    active_avro_enums.yml
    active_avro_ignore_filter.yml

### `active_avro_enums.yml`

Defines the ActiveRecord models that should be treated as enumerated values instead of full blown models.  By
convention the `id` attribute is assumed to be the enum's value and the `name` attribute its name - and this is what is
placed in the schema definition.  Because Avro's enums are zero based a 0-value name is automatically generated when
the enumeration's values are retrieved with the literal value "Unknown."

The options `zero_name`, `value_attribute_name` and `name_attribute_name` are configurable through the
`active_avro_enums.yml` file.

Example:

    AdGroupType: { }
    CampaignStatus: { zero_name: 'None', name_attribute_name: 'code' }

In the above example the ActiveRecord models AdGroupType and CampaignStatus will be placed in the schema definition
of any class associated with them as enums instead of records.

### `active_avro_ignore_filter.yml`

Defines the classes and attributes to ignore when generating the schema.  Some fields, like foreign key identifiers, may
not need to be serialized if the entire child class' hierarchy is included in the schema.  Wildcard (as `'*'` - ticks
required in a YAML file for the asterisk) and ActiveRecord class names can be placed in this file.  Regular expressions
may be specified for attribute names.

Example:

    AdStatus:
     - ad_groups
    '*':
     - created_at
     - updated_at
     - !ruby/regexp '/.*_id$/'
     - active_admin_comments
     - ads

In the above example the base ActiveRecord model class is `Ad` so we wildcard ignore anything that may include a
collection of ads, as well as several other attributes.  Additionally the `ad_groups` attribute for is of the AdStatus
ActiveRecord class type is also ignored.

## Dynamic Schema Generation

Generation of schemas at runtime can be done but it is costly in terms of CPU time.  Its recommended that schemas are
generated once and kept in memory for the lifetime of your application.  In memory schemas are necessary to serialize
ActiveRecord class instances to Avro.

Use the `ActiveAvro::Options` class to specify the path to your `active_avro_enums.yml` and `active_avro_ignore_filter.yml`
files at runtime:

    options = ActiveAvro::Options.new('config/active_avro_ignore_filter.yml', 'config/active_avro_enums.yml')
    ad_schema = Schema.new(Ad, options)

## Serialization

A schema can be used to serialize the class hierarchy for the model class its based upon:

    first_ad = Ad.first
    ad_hash = ad_schema.cast(first_ad)
    # at this point ad_hash is a Hash representative of the schema contained in ad_schema
    # you can use the JSON library to serialize it for transmission

## Working with the Apache Avro gem

The [Apache Avro](https://github.com/apache/avro/tree/trunk/lang/ruby) library works with JSON schema definitions for Avro and hashes.
The ActiveAvro gem was written specifically with this in mind:

    require 'avro'
    writer = StringIO.new
    schema = Avro::Schema.parse(ad_schema.to_json)
    dw = Avro::IO::DatumWriter.new(schema)
    dw.write(ad_hash, Avro::IO::BinaryEncoder.new(writer))

