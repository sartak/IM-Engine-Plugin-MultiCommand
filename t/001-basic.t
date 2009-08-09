#!/usr/bin/env perl
use strict;
use warnings;
use IM::Engine;
use Test::More tests => 4;

my @matched;
do {
    package MyTest::Dispatcher;
    use Path::Dispatcher::Declarative -base;

    on [['hello', 'hi']] => sub {
        push @matched, 'hello';
    };

    on [['bye', 'goodbye']] => sub {
        push @matched, 'bye';
    };
};

my $engine = IM::Engine->new(
    interface => {
        protocol => 'CLI',
    },
    plugins => [
        'MultiCommand',
        Dispatcher => {
            dispatcher => 'MyTest::Dispatcher',
        },
    ],
);

$engine->run("hello");
is_deeply([splice @matched], ["hello"]);

$engine->run("hi");
is_deeply([splice @matched], ["hello"]);

$engine->run("hi ;; bye");
is_deeply([splice @matched], ["hello", "bye"]);

$engine->run("hi;;foo;;bye");
is_deeply([splice @matched], ["hello", "bye"]);

