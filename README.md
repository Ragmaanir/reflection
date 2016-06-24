# reflection

Small library that provides macros in order to convert crystal expressions in you project into
a tree structure of `Reflection::Node`s that can be inspected and used at runtime.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  reflection:
    github: ragmaanir/reflection
```


## Usage


```crystal
require "reflection"

exp = Reflection.reflect_expression(4 + 5)
exp = exp.as(Reflection::Call)

assert exp.name == "+"
assert exp.receiver == Reflection::NumberLiteral.new(4)
assert exp.args[0] == Reflection::NumberLiteral.new(5)
```

## Development


## Contributing

1. Fork it ( https://github.com/ragmaanir/reflection/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[ragmaanir]](https://github.com/ragmaanir) ragmaanir - creator, maintainer
