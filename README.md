# An example Rails app that demonstrates DRY inclusion of helpful methods into RSpec specs

This scaffold of a Rails App is configured, in `spec/spec_helper.rb` to extend some example
groups with helpful methods. For the simplicity of illustration, the module,
`ControllerMacros` is included in `spec_helper.rb`.

## Rationale

I had read several accounts of using metadata matching to instruct RSpec to include or
extend modules into example groups. For example, here's 
[an especially good treatment of the subject of RSpec metadata](http://arjanvandergaag.nl/blog/using-abusing-rspec-metadata.html). 
My coding pair and I were trying to find a good way to
simulate a logged-in user for most, but not all, controller specs. In particular, we didn't
want to have a logged-in user for specs that tested logging in and out. One particularly
attractive way to target example groups for extension with helper methods was to use a `proc`
to test whether the class being tested was an `Action Controller`:

```
RSpec.configure do |config|

    config.extend ControllerMacros, { 
        described_class: -> described { described < ActionController::Base } 
    }
```

Only an example group with a `described_class` that made the body of the `proc` return
true--that is, one that was an ancestor of `ActionController::Base`--would be extended with
the ControllerMacros module.

By the way, the code `-> described { described < ActionController::Base }` is an example of 
a "stabby lambda", or a lambda written by the no-longer-very-new 
[lambda literal syntax](http://railspikes.com/2008/9/8/lambda-in-ruby-1-9)
introduced in Ruby 1.9.

See this project's `spec_helper.rb` and controller and model specs for an elaboration of
this strategy.

## Try it

I've included some slightly silly specs to demonstrate how extension works. They should
illustrate when extension and actual use occur.

Clone the repo, tweak the configuration as necessary, and run the specs. You should see
something like this.

```
[spec_example_groups_drive] rake
/your/path/to/ruby <...> ./spec/controllers/martinis_controller_spec.rb ./spec/models/martini_spec.rb
>>> Extended with ControllerMacros by PROC match
.>>> Extended with ControllerMacros by PROC match
....

Finished in 0.00634 seconds (files took 0.92366 seconds to load)
5 examples, 0 failures
```

There are a lot of ways to match metadata with filters. The RSpec source code is actually a
good place to look, as the precise methods for matching metadata have been changing over
time.

## Tricky Considerations

This kind of configuration adds simplicity to specs, but it adds complexity as well. It may
be easier to read the specs without explicit inclusion and calling of helper methods, but
now a code reader who wants to know how simulated users are "magically" logged-in will have
to find the code in the `spec_helper.rb` file, and in the file where the `ControllerMacros`
module would be separately defined in a respectable applicaiton, and understand how the
extension works. Also, a developer who wants to change the way this extension works has to
do the same, but her understanding has to be at a higher level to avoid messing things up.
This is the kind of trade-off developers have to consider all the time.

One especially tricky detail I want to mention: when you provide metadata filters to the
`Configuration#extend` method, as shown below, the extension happen if **any** of the
filters match. This goes for `Configuration#include` as well. You should not try to be 
overly specific about extension or inclusion, or you may have some surprising results. I
leave the filter for extension to check simply for a `described_class` that's a controller.

```
    # Extend an example group with a helper module iff the group describes a controller
    action_controller_extension_filter = {
      described_class: -> described { described < ActionController::Base }
    }

    config.extend ControllerMacros, action_controller_extension_filter
```

On the other hand, when specifying things that should happen within example groups, e.g. 
when to call a method in a `before` block, all the filters must match. So you *can* and 
*should* be specific.

    # Only call helper module's methods if metadata flag is also present
    action_controller_activation_filter = {
      described_class: -> described { described < ActionController::Base },
      prove_it: "proc"
    }

    config.before(:all, action_controller_activation_filter) do
        self.class.puts_proof_of_extensions_by_proc
        self.class.prove_by_letting_value
    end

## Disclaimer: The more things change...

This example is based on RSpec 3.0.0 and Rails 4.1.4. I doubt I'll be maintaining this repo
as things change, so the accuracy of what you're reading may degrade.
