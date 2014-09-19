# Parelation

[![Gem Version](https://badge.fury.io/rb/parelation.svg)](http://badge.fury.io/rb/parelation)
[![Code Climate](https://codeclimate.com/github/meskyanichi/parelation.png)](https://codeclimate.com/github/meskyanichi/parelation)
[![Build Status](https://travis-ci.org/meskyanichi/parelation.svg)](https://travis-ci.org/meskyanichi/parelation)

Parelation, for Rails/ActiveRecord 4.1.0+, allows you to query your ActiveRecord-mapped database easily, securely and quite flexibly using simple GET requests. It's used in your controller layer where it uses HTTP GET parameters to build on the ActiveRecord::Relation chain. This provides the client-side with the out-of-the-box flexibility to perform fairly dynamic queries without having to write boilerplate on the server.

This library was developed for- and extracted from [HireFire].

The documentation can be found on [RubyDoc].

### Compatibility

- Rails/ActiveRecord 4.1.0+
- Ruby (MRI) 2.0+
- Ruby (RBX) 2.2+

### Installation

Add the gem to your Gemfile and run `bundle`.

```rb
gem "parelation"
```

*This library won't be hosted on RubyGems.org until it's been tested more in development.*

### Example

Here's an example to get an idea of how it works. We'll fetch the `50` most recently created and `open` tickets, and we only want their `id`, `name` and `message` attributes.

```js
var params = {
  "select[]": ["id", "name", "message"],
  "where[state]": "open",
  "order": "created_at:desc",
  "limit": "50"
}

$.get("https://api.ticket.app/tickets", params, function(tickets){
  console.log("Just fetched the 50 most recent and open tickets.")
  $.each(tickets, function(ticket){
    console.log("Ticket " + ticket.name + " loaded!")
  })
})
```

Simply include `Parelation::Helpers` and use the `parelate` method. This will ensure that the provided parameters are converted and applied to the `Ticket.all` criteria chain.

```rb
class Api::V1::TicketsController < ApplicationController
  include Parelation::Helpers

  def index
    render json: parelate(Ticket.all)
  end
end
```

You can also scope results to the `current_user`:

```rb
class Api::V1::TicketsController < ApplicationController
  include Parelation::Helpers

  def index
    render json: parelate(current_user.tickets)
  end
end
```

Using the same JavaScript, this'll now fetch the 50 most recent open tickets scoped to the `current_user`.


### Parameter List (Reference)

Here follows a list of all possible query syntaxes. We'll assume we have a Ticket model to query on.

#### Select

```
/tickets?select[]=id&select[]=name&select[]=message
```

Translates to:

```rb
Ticket.select(:id, :name, :message)
```

#### Where

```
/tickets?where[state]=open
```

Translates to:

```rb
Ticket.where(state: "open")
```

You can also specify multiple multiple conditions:

```
/tickets?where[state][]=open&where[state][]=pending
```

Translates to:

```rb
Ticket.where(state: ["open", "pending"])
```

#### Where (directional)

* `where_gt` (greater than `>`)
* `where_gte` (greater than or equal to `>=`)
* `where_lt` (less than `<`)
* `where_lte` (less than or equal to `<=`)

```
/tickets?where_gt[created_at]=2014-01-01T00:00:00Z
```

Translates to:

```rb
Ticket.where("'tickets'.'created_at' > '2014-01-01 00:00:00.000000'")
```

You can also specify multiple conditions:

```
/tickets?where_gt[created_at]=2014-01-01T00:00:00Z&where_gt[updated_at]=2014-01-01T00:00:00Z
```

Translates to:

```rb
Ticket
  .where("'tickets'.'created_at' > '2014-01-01 00:00:00.000000'")
  .where("'tickets'.'updated_at' > '2014-01-01 00:00:00.000000'")
```

#### Query

```
/tickets?query[memory leak]=name
```

Translates to:

```rb
Ticket.where("'tickets'.'name' LIKE '%memory leak%'")
```

You can also specify multiple columns to scan:

```
/tickets?query[memory leak]=name&query[memory leak]=message
```

Translates to:

```rb
Ticket.where("(
  'tickets'.'name' LIKE '%memory leak%' OR
  'tickets'.'message' LIKE '%memory leak%'
)")
```

#### Order

```
/tickets?order=created_at:desc
```

Translates to:

```rb
Ticket.order(created_at: :desc)
```

You can also specify multiple order-operations:

```
/tickets?order[]=created_at:desc&order[]=name:asc
```

Translates to:

```rb
Ticket.order(created_at: :desc, name: :asc)
```

#### Limit

```
/tickets?limit=50
```

Translates to:

```rb
Ticket.limit(50)
```

#### Offset

```
/tickets?offset=25
```

Translates to:

```rb
Ticket.offset(25)
```


### Error Handling

When invalid parameters were sent, you can rescue the exception and return a message to the client.

```rb
class Api::V1::TicketsController < ApplicationController
  include Parelation::Helpers

  def index
    render json: parelate(Ticket.all)
  rescue Parelation::Errors::Parameter => error
    render json: { error: error }, status: :bad_request
  end
end
```

This will tell client developers what parameter failed in the HTTP response. This exception generally occurs when there is a typo in the URL's parameters. Knowing which parameter failed (described in `error`) helps narrowing down the issue.


### Contributing

Contributions are welcome, but please conform to these requirements:

- Ruby (MRI) 2.0+
- Ruby (RBX) 2.2+
- ActiveRecord 4.1.0+
- 100% Spec Coverage
  - Generated by when running the test suite
- 100% [Passing Specs]
  - Run test suite with `$ rspec spec`
- 4.0 [Code Climate Score]
  - Run `$ rubycritic lib` to generate the score locally and receive tips
  - No code smells
  - No duplication

To start contributing, fork the project, clone it, and install the development dependencies:

```
git clone git@github.com:USERNAME/parelation.git
cd parelation
bundle
```

Ensure that everything works:

```
rspec spec
rubycritic lib
```

Create a new branch and start hacking:

```
git checkout -b my-contributions
```

Submit a pull request.


### Author / License

Copyright (c) 2014 Michael van Rooijen ( [@meskyanichi] )<br />
Released under the MIT [License].

[@meskyanichi]: https://twitter.com/meskyanichi
[HireFire]: http://hirefire.io
[Passing Specs]: https://travis-ci.org/meskyanichi/parelation
[Code Climate Score]: https://codeclimate.com/github/meskyanichi/parelation
[RubyDoc]: http://rubydoc.info/github/meskyanichi/parelation/master/frames
[License]: https://github.com/meskyanichi/parelation/blob/master/LICENSE
