# TDD By Example: Money

## About

This is the code from the ShRUG coding sessions we did, where we worked through
Kent Beck's [Test-Driven Development by Example][TDDbE].

Note the branch structure:

* master: contains the code I (Ash) wrote working through the example beforehand
* shrug8: contains the code from ShRUG 8
* shrug9: will contain the code from ShRUG 9

[TDDbE]: http://www.goodreads.com/book/show/6408726-test-driven-development-by-example

## Installation

    rvm install 1.9.2
    rvm use 1.9.2
    rvm gemset create 'tdd_by_example_money'
    gem install bundler
    cd money
    bundle install

(Note: this relies on the .rvmrc file present in the root of the project.)