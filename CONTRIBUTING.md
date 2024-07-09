This module has grown over time based on a range of contributions from
people using it. If you follow these contributing guidelines your patch
will likely make it into a release a little quicker.

## Contributing

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and
   it's great to know that you have a clean slate.

3. Add a test for your change. Only refactoring and documentation
   changes require no new tests. If you are adding functionality
   or fixing a bug, please add a test.

4. Make the test pass.

5. Push to your fork and submit a pull request.

## Dependencies

The testing and development tools have a bunch of dependencies,
all managed by [Bundler](http://bundler.io/) according to the
[Puppet support matrix](http://docs.puppetlabs.com/guides/platforms.html#ruby-versions).

By default the tests use a baseline version of Puppet.

Install the dependencies like so...

    ```shell
    bundle install
    ```

## Syntax and style

The test suite will run [Puppet Lint](http://puppet-lint.com/), [rubocop](https://github.com/rubocop-hq/rubocop) and
[Puppet Syntax](https://github.com/gds-operations/puppet-syntax) to
check various syntax and style things. You can run these locally with:

    ```shell
    bundle exec rake lint
    bundle exec rake syntax
    bundle exec rake rubocop
    ```

## Running the unit tests

The unit test suite covers most of the code, as mentioned above please
add tests if you're adding new functionality. If you've not used
[rspec-puppet](http://rspec-puppet.com/) before then feel free to ask
about how best to test your new feature. Running the test suite is done
with:

    ```shell
    bundle exec rake spec
    ```

Note also you can run the syntax, style and unit tests in one go with:

    ```shell
    bundle exec rake test
    ```

## Acceptance tests

The unit tests just check the code runs, not that it does exactly what
we want on a real machine. For that we're using
[Litmus](https://github.com/puppetlabs/puppet_litmus).

Litmus fires up a new docker instance using hypervisor of your choice and runs a series of
simple tests against it after applying the module. You can run our
Litmus acceptance tests with following commands:

    ```shell
    bundle exec rake 'litmus:provision[docker, ubuntu:18.04]'
    bundle exec rake litmus:install_agent
    bundle exec rake litmus:install_module
    bundle exec rake litmus:acceptance:parallel
    ```

The above commands will create a container using docker and ubuntu version 18.04, install puppet and the uamsclient module and will start executing the acceptance tests. To run against an another host, follow the steps [here](https://github.com/puppetlabs/puppet_litmus/wiki/Litmus-core-commands). 

To run against a set of environments, modify the `provision.yaml` and create your own list of environments. For example, the below command will create a set of environments as defined under the label `release_checks`:

    ```shell
    bundle exec rake 'litmus:provision_list[release_checks]'
    ```
Then you can check the list of created containers by running the command

    ```shell
    docker ps
    ```