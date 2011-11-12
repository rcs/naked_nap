# Naked Nap
A "naked" wrapper, exposing your objects out to the web.

## Installation
```shell
gem install naked_nap
```

## Example Usage
```ruby
# config.ru
require 'naked_nap'

class Caeser
  def rot13(s)
    s.tr "A-Za-z", "N-ZA-Mn-za-m"
  end
end

run NakedNap.new Caeser
```
``` shell
curl http://localhost:9292/rot13/kitties
# => "xvggvrf"
# Quotation marks come from json encoding
```
